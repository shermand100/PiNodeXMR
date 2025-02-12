// Helper function to update text content for an element
function updateField(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = value || 'N/A';
    }
}

// Helper function to clear and populate a table
function populateTable(tableId, data, columns) {
    const tableBody = document.getElementById(tableId);
    if (!tableBody) return;

    // Clear existing rows
    tableBody.innerHTML = '';

    // Populate with new rows
    data.forEach((item) => {
        const row = document.createElement('tr');
        columns.forEach((column) => {
            const cell = document.createElement('td');
            cell.textContent = item[column] || 'N/A';
            row.appendChild(cell);
        });
        tableBody.appendChild(row);
    });
}

async function fetchNetworkStats() {
    try {
        const response = await fetch("api/network/stats");
        if (!response.ok) throw new Error(`Network stats error: ${response.status}`);
        const data = await response.json();

        // Calculate Network Hashrate: Difficulty / Block Time (120 seconds)
        const blockTime = 120; // Monero block time
        const networkHashrate = data.difficulty / blockTime; // Hashrate in H/s

        // Convert to GH/s (divide by 1e9) and ensure it is formatted correctly
        const networkHashrateGH = (networkHashrate / 1e9).toFixed(2); // Converts to GH/s with 2 decimal places

        // Update fields in the UI
        updateField("network_difficulty", data.difficulty?.toLocaleString());
        updateField("network_block_height", data.height);
        updateField("network_block_hash", data.hash);

        // Ensure block reward is formatted correctly
        const formattedReward = (data.reward / 1e12).toFixed(12); // Adjust for piconero
        updateField("network_block_reward", `${formattedReward} XMR`);

        // Add Network Hashrate in GH/s
        updateField("network_hashrate", `${networkHashrateGH} GH/s`);

        // Format and display timestamp
        updateField("network_timestamp", new Date(data.timestamp * 1000).toLocaleString());
    } catch (error) {
        console.error("Error fetching Network Statistics:", error);
    }
}


// Fetch and populate Pool Statistics
async function fetchPoolStats() {
    try {
        const [poolStatsRes, poolBlocksRes, networkStatsRes] = await Promise.all([
            fetch("api/pool/stats"),
            fetch("api/pool/blocks"),
            fetch("api/network/stats"),
        ]);

        if (!poolStatsRes.ok || !poolBlocksRes.ok || !networkStatsRes.ok) {
            throw new Error("Failed to fetch required data for Pool Statistics.");
        }

        const [poolStats, poolBlocks, networkStats] = await Promise.all([
            poolStatsRes.json(),
            poolBlocksRes.json(),
            networkStatsRes.json(),
        ]);

        const stats = poolStats.pool_statistics;

        updateField("pool_hashrate", (stats.hashRate / 1e6).toFixed(2) + " MH/s");
        updateField("pool_miners", stats.miners);
        updateField("pool_total_hashes", stats.totalHashes?.toLocaleString());
        updateField("pool_last_block_time", stats.lastBlockFoundTime
            ? new Date(stats.lastBlockFoundTime * 1000).toLocaleString()
            : "N/A");
        updateField("pool_last_block_found", stats.lastBlockFound);
        updateField("pool_total_blocks_found", stats.totalBlocksFound);
        updateField("pool_pplns_weight", stats.pplnsWeight?.toLocaleString());
        updateField("pool_pplns_window_size", stats.pplnsWindowSize);
        updateField("pool_sidechain_difficulty", stats.sidechainDifficulty?.toLocaleString());
        updateField("pool_sidechain_height", stats.sidechainHeight);

        const lastBlockTimestamp = stats.lastBlockFoundTime
            ? new Date(stats.lastBlockFoundTime * 1000)
            : null;
        if (lastBlockTimestamp) {
            const now = new Date();
            const diffMs = now - lastBlockTimestamp;
            const timeSinceLastBlock = formatElapsedTime(diffMs / 1000);
            updateField("pool_time_since_last_block", timeSinceLastBlock);
        } else {
            updateField("pool_time_since_last_block", "N/A");
        }

        const curEffort = calculateEffort(
            stats.totalHashes,
            poolBlocks[0]?.totalHashes || 0,
            networkStats.difficulty
        );
        setEffort(document.getElementById("pool_current_effort"), curEffort);
    } catch (error) {
        console.error("Error fetching Pool Statistics:", error);
    }
}

// Effort calculation helper
function calculateEffort(totalHashes, blockHashes, difficulty) {
    if (!difficulty) return 0;
    return ((totalHashes - blockHashes) * 100) / difficulty;
}

// Update effort display
function setEffort(el, value) {
    el.innerHTML = `${value.toFixed(2)}%`;
    el.style.color = value < 100 ? "#00C000" : value < 200 ? "#E0E000" : "#FF0000";
}

// Fetch and populate P2P Statistics
async function fetchP2PStats() {
    try {
        const response = await fetch("api/local/p2p");
        if (!response.ok) throw new Error(`P2P stats error: ${response.status}`);
        const data = await response.json();

        updateField("p2p_connections", data.connections);
        updateField("p2p_incoming_connections", data.incoming_connections);
        updateField("p2p_peer_list_size", data.peer_list_size);

        const peersTableBody = document.querySelector("#p2p_peers_table tbody");
        if (!peersTableBody) return;

        // Create a map to track existing rows by IP
        const existingRows = {};
        peersTableBody.querySelectorAll("tr").forEach(row => {
            const ip = row.dataset.ip;
            if (ip) existingRows[ip] = row;
        });

        for (const peer of data.peers) {
            const [direction, uptime, latency, version, height, address] = peer.split(",");
            const ip = address.split(":")[0]; // Extract IP address

            // Check if row already exists
            if (existingRows[ip]) {
                const row = existingRows[ip];
                row.querySelector(".uptime").textContent = formatUptime(uptime);
                row.querySelector(".latency").textContent = `${latency} ms`;
                row.querySelector(".height").textContent = height;
                continue; // Skip creating a new row
            }

            // Create a new row
            const row = document.createElement("tr");
            row.dataset.ip = ip; // Store IP for quick lookup
            row.innerHTML = `
                <td>${direction === "I" ? "Inbound" : "Outbound"}</td>
                <td class="uptime">${formatUptime(uptime)}</td>
                <td class="latency">${latency} ms</td>
                <td>${version}</td>
                <td class="height">${height}</td>
                <td>${ip}</td>
            `;
            peersTableBody.appendChild(row);
        }
    } catch (error) {
        console.error("Error fetching P2P Statistics:", error);
    }
}

async function fetchMinerStats() {
    try {
        const response = await fetch('api/local/miner');
        if (!response.ok) throw new Error(`Miner stats error: ${response.status}`);
        const data = await response.json();

        // Update Miner Statistics fields
        updateField("miner_current_hashrate", (data.current_hashrate / 1000).toFixed(2) + " KH/s");
        updateField("miner_total_hashes", data.total_hashes?.toLocaleString());
        updateField("miner_uptime", formatUptime(data.time_running));
        updateField("miner_shares_found", data.shares_found);
        updateField("miner_shares_failed", data.shares_failed);
        updateField("miner_block_reward_share_percent", data.block_reward_share_percent?.toFixed(3) + "%");
        updateField("miner_threads", data.threads);
    } catch (error) {
        console.error("Error fetching Miner Statistics:", error);
    }
}

// Helper function to update text content of an element by ID
function updateField(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.textContent = value;
    }
}

// Helper function to format uptime in seconds to HH:MM:SS
function formatUptime(seconds) {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);
    return `${hrs}h ${mins}m ${secs}s`;
}

// Call fetchMinerStats on page load
document.addEventListener("DOMContentLoaded", () => {
    fetchMinerStats();
    // Optionally, refresh data every minute
    setInterval(fetchMinerStats, 60000);
});


// Helper function to set colored text based on value thresholds
function setEffortColor(element, value) {
    if (!element) return;
    element.textContent = value.toFixed(2) + "%";
    element.style.color = value < 100
        ? "#00C000" // Green
        : value < 200
        ? "#E0E000" // Yellow
        : "#FF0000"; // Red
}

// Helper function to format uptime dynamically
function formatUptime(seconds) {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;

    // Only add non-zero values to the output
    const parts = [];
    if (hrs) parts.push(`${hrs} hrs`);
    if (mins) parts.push(`${mins} min`);
    if (secs || parts.length === 0) parts.push(`${secs} sec`); // Show seconds as fallback

    return parts.join(" ");
}

// Fetch and populate Stratum Statistics
async function fetchStratumStats() {
    try {
        const response = await fetch("api/local/stratum");
        if (!response.ok) {
            throw new Error(`Stratum stats error: ${response.status}`);
        }
        const data = await response.json();

        // Update basic statistics fields
        updateField("stratum_hashrate_15m", formatHashrate(data.hashrate_15m));
        updateField("stratum_hashrate_1h", formatHashrate(data.hashrate_1h));
        updateField("stratum_hashrate_24h", formatHashrate(data.hashrate_24h));
        updateField("stratum_total_hashes", data.total_hashes?.toLocaleString());
        updateField("stratum_shares_found", data.shares_found);
        updateField("stratum_shares_failed", data.shares_failed);
        setEffortColor(document.getElementById("stratum_average_effort"), data.average_effort || 0);
        setEffortColor(document.getElementById("stratum_current_effort"), data.current_effort || 0);
        updateField("stratum_block_reward_share_percent", formatPercentage(data.block_reward_share_percent));
        updateField("stratum_connections", data.connections);
        updateField("stratum_incoming_connections", data.incoming_connections);

        function populateTable(tableId, data, columns) {
            const tableBody = document.getElementById(tableId).querySelector("tbody");
            if (!tableBody) return;

            // Clear existing rows (except the header row, if any)
            while (tableBody.firstChild) {
                tableBody.removeChild(tableBody.firstChild);
            }

            // Populate the table with worker rows
            data.forEach(item => {
                const row = document.createElement("tr");
                columns.forEach(column => {
                    const cell = document.createElement("td");
                    cell.textContent = item[column] || "N/A";
                    row.appendChild(cell);
                });
                tableBody.appendChild(row);
            });
        }

        // Process workers data and populate the table
        const workers = data.workers || [];
        const uniqueWorkers = Array.from(new Set(workers.map(worker => worker.split(",")[0])))
            .map(address => workers.find(worker => worker.startsWith(address)));

        const formattedWorkers = uniqueWorkers.map(worker => {
            const [address, uptime, difficulty, hashrate, identifier] = worker.split(",");
            return {
                address: address || "N/A",
                uptime: uptime ? formatUptime(parseInt(uptime, 10)) : "N/A",
                difficulty: difficulty || "N/A",
                hashrate: hashrate ? `${(parseFloat(hashrate) / 1000).toFixed(2)} KH/s` : "N/A",
                identifier: identifier || "N/A"
            };
        });

        populateTable("stratum_workers_table", formattedWorkers, ["address", "uptime", "difficulty", "hashrate", "identifier"]);

        // Calculate and update shares in the payment window
        const sharesInWindow = calculateSharesInWindow(data.block_reward_share_percent);
        updateField("shares_in_window", sharesInWindow);

        // Fetch and update time since last share
        const lastShareTimestamp = await getLastShareTimestampFromLogs();
        const timeSinceLastShare = calculateTimeSinceLastShare(lastShareTimestamp);
        updateField("time_since_last_share", timeSinceLastShare);
    } catch (error) {
        console.error("Error fetching Stratum Statistics:", error);
    }
}

// Helper to parse logs and fetch the last share timestamp
async function getLastShareTimestampFromLogs() {
    const logFileUrl = "p2pool.log"; // Replace with actual log file URL
    try {
        const response = await fetch(logFileUrl);
        if (!response.ok) throw new Error(`Failed to fetch log file: ${response.status}`);
        const logData = await response.text();

        // Regular expression to extract the timestamp of the last share
        const shareRegex = /NOTICE\s+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)\s+StratumServer SHARE FOUND:/g;
        const matches = [...logData.matchAll(shareRegex)];

        // Return the last match
        if (matches.length > 0) {
            return matches[matches.length - 1][1]; // Return the last timestamp as a string
        } else {
            console.warn("No shares found in the log file.");
            return null;
        }
    } catch (error) {
        console.error("Error fetching or parsing log file:", error);
        return null;
    }
}

// Helper to calculate elapsed time in a human-readable format
function calculateTimeSinceLastShare(lastShareTimestamp) {
    if (!lastShareTimestamp) return "N/A";

    const lastTime = lastShareTimestamp * 1000; // Assuming timestamp is in seconds
    const now = Date.now();

    const elapsedSeconds = Math.floor((now - lastTime) / 1000);
    const hours = Math.floor(elapsedSeconds / 3600);
    const minutes = Math.floor((elapsedSeconds % 3600) / 60);
    const seconds = elapsedSeconds % 60;

    return `${hours}h ${minutes}m ${seconds}s`;
}


// Helper to calculate shares in the payment window
function calculateSharesInWindow(sharePercent) {
    if (!sharePercent) return 0;
    const paymentWindow = 2160; // Fixed payment window size
    return Math.round((sharePercent / 100) * paymentWindow);
}



// Helper to format hashrate values
function formatHashrate(hashrate) {
    return `${(hashrate / 1000).toFixed(2)} KH/s`;
}

// Helper to format percentage values
function formatPercentage(value) {
    return value ? `${value.toFixed(3)}%` : "N/A";
}


// Helper function to calculate shares in the payment window
function calculateSharesInWindow(sharePercent) {
    if (!sharePercent) return "N/A";
    return Math.round((sharePercent / 100) * 2160); // Assuming 2160 as the PPLNS window size
}


// Show/Hide tables (Peers & Workers)
function togglePeers() {
    const peersTable = document.getElementById("p2p_peers_table");
    if (peersTable) {
        peersTable.classList.toggle("hidden");
        console.log("Peers table visibility toggled");
    }
}

function toggleWorkers() {
    const workersTable = document.getElementById("stratum_workers_table");
    if (workersTable) {
        workersTable.classList.toggle("hidden");
        console.log("Workers table visibility toggled");
    }
}


// Function to toggle blocks visibility
function toggleBlocks() {
    const rows = document.querySelectorAll("#blocks_table tbody tr");
    const toggleButton = document.querySelector(".toggle-button");

    // Determine if additional rows are currently hidden
    const isExpanded = Array.from(rows).some((row, index) => index >= 5 && row.style.display !== "none");

    rows.forEach((row, index) => {
        if (index >= 5) {
            row.style.display = isExpanded ? "none" : "table-row";
        }
    });

    // Update button text
    //toggleButton.textContent = isExpanded ? "Show Blocks" : "Hide Blocks";
}

// Fetch and populate blocks with effort calculations
async function fetchBlocks() {
    try {
        const response = await fetch("api/pool/blocks");
        if (!response.ok) throw new Error(`Blocks API error: ${response.status}`);
        const blocksData = await response.json();

        const tableBody = document.querySelector("#blocks_table tbody");
        tableBody.innerHTML = ""; // Clear existing rows

        blocksData.slice(0, 20).forEach((block, index) => {
            const row = document.createElement("tr");

            // Block Height Cell with Link
            const heightCell = document.createElement("td");
            const heightLink = document.createElement("a");
            heightLink.href = `https://p2pool.io/explorer/block/${block.hash}`;
            heightLink.target = "_blank";
            heightLink.textContent = block.height;
            heightLink.style.color = "#00bfff";
            heightCell.appendChild(heightLink);
            row.appendChild(heightCell);

            // Effort Cell
            const effortCell = document.createElement("td");
            const effort = index + 1 < blocksData.length
                ? calculateEffort(block.totalHashes, blocksData[index + 1]?.totalHashes || 0, block.difficulty)
                : "N/A";
            effortCell.textContent = effort === "N/A" ? "N/A" : `${effort.toFixed(2)}%`;
            effortCell.style.color = effort < 100 ? "#00C000" : effort < 200 ? "#E0E000" : "#FF0000";
            row.appendChild(effortCell);

            // Age Cell
            const ageCell = document.createElement("td");
            ageCell.textContent = formatElapsedTime((Date.now() / 1000) - block.ts);
            row.appendChild(ageCell);

            // Hide rows beyond the first 5 by default
            if (index >= 5) {
                row.style.display = "none";
            }

            tableBody.appendChild(row);
        });
    } catch (error) {
        console.error("Error fetching blocks data:", error);
    }
}

// Calculate effort percentage
function calculateEffort(totalHashes, previousTotalHashes, difficulty) {
    if (!difficulty || totalHashes <= previousTotalHashes) return "N/A";
    return ((totalHashes - previousTotalHashes) / difficulty) * 100;
}

// Format elapsed time in human-readable format
function formatElapsedTime(seconds) {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);

    if (days > 0) return `${days}d ${hours}h`;
    if (hours > 0) return `${hours}h ${minutes}m`;
    return `${minutes}m`;
}

// Initialize all data fetching
function initializeDataFetching() {
    fetchNetworkStats();
    fetchPoolStats();
    fetchP2PStats();
    fetchStratumStats();
    fetchBlocks();

    setInterval(fetchNetworkStats, 10000);
    setInterval(fetchPoolStats, 10000);
    setInterval(fetchP2PStats, 10000);
    setInterval(fetchStratumStats, 10000);
    setInterval(fetchBlocks, 30000);
}

document.addEventListener("DOMContentLoaded", initializeDataFetching);
