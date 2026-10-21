<?php
/**
 * pinode_security.php
 *
 * Shared server-side security helpers for the PiNode-XMR web console.
 *
 * Background
 * ----------
 * Several endpoints in this directory accept a value from the browser and
 * persist it into a shell fragment under /home/pinodexmr/variables/*.sh (or an
 * execScript). Those fragments are later `source`d, or expanded unquoted, by
 * the node start-up scripts which run as the `pinodexmr` user. Because that
 * account historically has passwordless sudo, any attacker-controlled value
 * that reaches one of those files without validation becomes command execution
 * on the host.
 *
 * These helpers centralise:
 *   - strict allow-list validation of every accepted value,
 *   - safe, single-quoted writing of shell variables so a value can never
 *     break out of its assignment even if validation is ever loosened, and
 *   - HTML-escaped output so reflected values cannot introduce XSS.
 *
 * The functions intentionally fail closed: an invalid value produces an
 * HTTP 400 and writes nothing.
 */

/**
 * Read the posted "value" field. Requires a POST request.
 *
 * @return string The raw posted value (not yet validated).
 */
function pn_read_value()
{
    if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
        pn_fail('This endpoint only accepts POST requests.');
    }
    if (!isset($_POST['value'])) {
        pn_fail('Missing required "value" field.');
    }
    // Reject arrays and other non-scalar payloads.
    if (!is_string($_POST['value'])) {
        pn_fail('Invalid "value" field.');
    }
    return $_POST['value'];
}

/**
 * Abort the request with a 400 and a safe, HTML-escaped message.
 *
 * @param string $message Human readable reason.
 */
function pn_fail($message)
{
    http_response_code(400);
    echo 'Rejected: ' . pn_h($message);
    exit;
}

/**
 * HTML-escape a value for safe echoing back to the browser.
 *
 * @param string $value
 * @return string
 */
function pn_h($value)
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

/**
 * Escape a validated value for inclusion inside single quotes in a bash file.
 * Values that pass the validators here never contain single quotes, but this
 * provides defence in depth against future changes.
 *
 * @param string $value
 * @return string
 */
function pn_shell_single_quote($value)
{
    return "'" . str_replace("'", "'\\''", (string) $value) . "'";
}

/**
 * Atomically write a bash variable-assignment fragment.
 *
 * Produces:
 *   #!/bin/bash
 *   NAME='value'
 *
 * The value is single-quoted and escaped so it cannot inject additional shell
 * when the fragment is sourced.
 *
 * @param string $path     Destination path.
 * @param string $name     Shell variable name (must be a valid identifier).
 * @param string $value    Already-validated value.
 */
function pn_write_shell_var($path, $name, $value)
{
    if (!preg_match('/^[A-Za-z_][A-Za-z0-9_]*$/', $name)) {
        pn_fail('Internal error: invalid variable name.');
    }
    $contents = "#!/bin/bash\n" . $name . '=' . pn_shell_single_quote($value) . "\n";
    pn_write_file($path, $contents);
}

/**
 * Write plain contents to a file via a temp file + rename for atomicity.
 *
 * The replacement file must stay readable by the node account (`pinodexmr`),
 * which sources these fragments. tempnam() creates files as 0600 owned by the
 * web user, so a naive rename would leave the node unable to read its own
 * settings once permissions are tightened. The mode of the file being replaced
 * is therefore preserved (defaulting to 0664, matching the group-shared model
 * in harden-permissions.sh).
 *
 * @param string $path
 * @param string $contents
 */
function pn_write_file($path, $contents)
{
    // Preserve the existing permissions where the file is already present.
    $mode = 0664;
    if (file_exists($path)) {
        $existing = @fileperms($path);
        if ($existing !== false) {
            $mode = $existing & 0777;
        }
    }

    $dir = dirname($path);
    $tmp = @tempnam($dir, '.pn');
    if ($tmp !== false && @file_put_contents($tmp, $contents) !== false) {
        @chmod($tmp, $mode);
        if (@rename($tmp, $path)) {
            return;
        }
        @unlink($tmp);
    } elseif ($tmp !== false) {
        @unlink($tmp);
    }

    // Fall back to an in-place write when the directory is not writable (the
    // hardened layout deliberately exposes only the target file, not the
    // directory) or the rename could not be completed.
    if (@file_put_contents($path, $contents) === false) {
        pn_fail('Could not persist the requested value.');
    }
    @chmod($path, $mode);
}

/* --------------------------------------------------------------------------
 * Validators. Each returns the normalised value or aborts via pn_fail().
 * ------------------------------------------------------------------------ */

/**
 * Validate an integer within an inclusive range.
 *
 * @param string $value
 * @param int    $min
 * @param int    $max
 * @param string $label
 * @return string The normalised integer as a string.
 */
function pn_int_range($value, $min, $max, $label = 'value')
{
    $value = trim($value);
    if (!preg_match('/^-?\d+$/', $value)) {
        pn_fail($label . ' must be a whole number.');
    }
    $n = (int) $value;
    if ($n < $min || $n > $max) {
        pn_fail($label . ' must be between ' . $min . ' and ' . $max . '.');
    }
    return (string) $n;
}

/**
 * Validate a TCP/UDP port number (1-65535).
 */
function pn_port($value, $label = 'Port')
{
    return pn_int_range($value, 1, 65535, $label);
}

/**
 * Validate a Monero primary/integrated address.
 *
 * Monero addresses are Base58 (no 0, O, I, l). Standard addresses are 95
 * characters, integrated addresses 106. P2Pool requires a primary address
 * (starts with 4). We accept 4/8 prefixes and the two canonical lengths.
 */
function pn_monero_address($value, $label = 'Monero address')
{
    $value = trim($value);
    $len = strlen($value);
    if ($len !== 95 && $len !== 106) {
        pn_fail($label . ' has an unexpected length.');
    }
    if (!preg_match('/^[48][123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz]+$/', $value)) {
        pn_fail($label . ' is not a valid Base58 Monero address.');
    }
    return $value;
}

/**
 * Validate an I2P destination / address.
 *
 * Accepts a conservative character set covering .b32.i2p hostnames and
 * base64 destinations (with i2p's altchars ~ and -), plus a trailing ".i2p".
 * No shell metacharacters or whitespace are permitted.
 */
function pn_i2p_address($value, $label = 'I2P address')
{
    $value = trim($value);
    if ($value === '' || strlen($value) > 600) {
        pn_fail($label . ' is empty or too long.');
    }
    if (!preg_match('/^[A-Za-z0-9~=._-]+$/', $value)) {
        pn_fail($label . ' contains invalid characters.');
    }
    return $value;
}

/**
 * Validate an HTTP(S)/WS(S) endpoint URL for the Ethereum JSON-RPC node.
 */
function pn_rpc_url($value, $label = 'RPC node URL')
{
    $value = trim($value);
    if (strlen($value) > 2000) {
        pn_fail($label . ' is too long.');
    }
    if (!preg_match('#^(https?|wss?)://[A-Za-z0-9._~:/?\#\[\]@!$&\'()*+,;=%-]+$#', $value)) {
        pn_fail($label . ' must be a valid http(s):// or ws(s):// URL.');
    }
    // Disallow characters that are unnecessary for a URL and dangerous in a
    // shell context, even though the value is written single-quoted.
    if (preg_match('/[`$\\\\ \t\r\n]/', $value)) {
        pn_fail($label . ' contains invalid characters.');
    }
    return $value;
}

/**
 * Validate a user-supplied custom monerod command line.
 *
 * This is the most sensitive input in the console: the returned string is
 * written verbatim as an executable line in an execScript that runs as the
 * `pinodexmr` service account. It is impossible to make an arbitrary command
 * line fully safe, so we constrain it as tightly as the feature allows:
 *
 *   - it must invoke monerod (./monerod or ./monero/.../monerod),
 *   - it may only contain a conservative character set that covers monerod
 *     flags and their values (no shell metacharacters), and
 *   - no command separators, substitution, redirection or quoting are allowed,
 *     which blocks chaining a second command onto the monerod invocation.
 *
 * @param string $value
 * @return string
 */
function pn_custom_monero_command($value)
{
    $value = trim($value);
    if ($value === '' || strlen($value) > 2000) {
        pn_fail('Custom command is empty or too long.');
    }
    if (preg_match('/[\r\n]/', $value)) {
        pn_fail('Custom command must be a single line.');
    }
    // Block every shell metacharacter that could chain, substitute, redirect,
    // quote, glob or background a command.
    if (preg_match('/[;&|`$(){}<>\\\\\'"!*?\[\]#~]/', $value)) {
        pn_fail('Custom command contains disallowed shell metacharacters.');
    }
    // Allow-list: letters, digits, whitespace, and the punctuation used by
    // monerod flags and values.
    if (!preg_match('#^[A-Za-z0-9 \t_./:,=@%+-]+$#', $value)) {
        pn_fail('Custom command contains invalid characters.');
    }
    // Must actually launch monerod, not an arbitrary program.
    if (!preg_match('#^(\./)?(monero/build/release/bin/)?monerod(\s|$)#', $value)) {
        pn_fail('Custom command must start by launching monerod (e.g. "./monerod --flags").');
    }
    return $value;
}

/**
 * Validate the P2Pool sidechain selector. Only the known chain flags are
 * permitted; anything else (including the legacy "&" main-chain marker) maps
 * to the empty string, i.e. the main chain with no extra flag.
 */
function pn_p2pool_chain($value)
{
    $value = trim($value);
    if ($value === '--mini' || $value === '--nano') {
        return $value;
    }
    return '';
}
