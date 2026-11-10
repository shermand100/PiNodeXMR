/*
 * pinode-csrf.js
 *
 * Attaches the X-PiNode-CSRF header to every AJAX request the console makes.
 *
 * The server requires this header on all state-changing endpoints. A cross-site
 * <form>, <img> or <script> cannot set a custom header, and an XHR or fetch
 * that tries triggers a CORS preflight which the console answers without any
 * Access-Control-Allow-* header - so the browser blocks the real request. That
 * makes the header's presence sufficient evidence the request came from a
 * console page loaded from this origin.
 *
 * Must load after jquery.min.js and before any script that issues requests.
 */
(function () {
    if (typeof jQuery === 'undefined') {
        // Without jQuery the console's own calls cannot be made either, so
        // there is nothing to protect; fail quietly rather than break the page.
        return;
    }
    jQuery.ajaxSetup({
        headers: { 'X-PiNode-CSRF': '1' }
    });
})();
