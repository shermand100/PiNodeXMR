#!/bin/bash
# setup-grafana-monitoring.sh — optional Grafana monitoring for PiNode-XMR.
#
# Installs the PiNodeXMR Grafana Dashboard add-on, which exports monerod's RPC
# statistics as Prometheus metrics and displays them on a prepared dashboard.
#
# Two ways to run it:
#   * on this device — Grafana and Prometheus are installed here and served on
#     a port of your choosing
#   * as an agent — this device only reports, and Grafana lives elsewhere on
#     your network or in the cloud
#
# Project: https://github.com/ChiefGyk3D/PiNodeXMR_Grafana_Dashboard

MONITORING_REPO="https://github.com/ChiefGyk3D/PiNodeXMR_Grafana_Dashboard"
# Cloned into a root-owned location, NOT /home/pinodexmr: the add-on is run
# with sudo, so its code must not sit in a directory the unprivileged
# pinodexmr account could modify between download and root execution.
MONITORING_DIR="/opt/pinodexmr-monitoring-src"
MONITORING_BRANCH="main"

# Fetch the add-on, or update an existing checkout. All repo operations run as
# root (sudo) so the checkout stays root-owned.
get_monitoring_repo() {
	if sudo test -d "${MONITORING_DIR}/.git"; then
		TERM=vt220 whiptail --infobox "Please Wait...\n\nUpdating the monitoring add-on from GitHub" 12 78
		sudo git -C "${MONITORING_DIR}" fetch --depth 1 origin "${MONITORING_BRANCH}" >/dev/null 2>&1
		sudo git -C "${MONITORING_DIR}" reset --hard "origin/${MONITORING_BRANCH}" >/dev/null 2>&1
	else
		TERM=vt220 whiptail --infobox "Please Wait...\n\nDownloading the monitoring add-on from GitHub" 12 78
		sudo rm -rf "${MONITORING_DIR}"
		sudo git clone --depth 1 -b "${MONITORING_BRANCH}" "${MONITORING_REPO}" "${MONITORING_DIR}" >/dev/null 2>&1
	fi

	if ! sudo test -f "${MONITORING_DIR}/install.sh"; then
		whiptail --title "PiNode-XMR Monitoring" --msgbox "Could not download the monitoring add-on.\n\nCheck this device's internet connection and try again.\n\nRepository: ${MONITORING_REPO}" 14 78
		return 1
	fi

	sudo chmod +x "${MONITORING_DIR}/install.sh" "${MONITORING_DIR}/uninstall.sh" 2>/dev/null
	return 0
}

CHOICE=$(whiptail --backtitle "Welcome" --title "PiNode-XMR Grafana Monitoring" --menu "\n\nGrafana Monitoring Dashboard" 20 70 10 \
	"1)" "Install / Reconfigure Monitoring" \
	"2)" "Show Monitoring Status" \
	"3)" "Update Monitoring Add-on" \
	"4)" "Uninstall Monitoring" \
	"5)" "About / Help" \
	"6)" "Back to Main Menu" 2>&1 >/dev/tty)

case $CHOICE in

	"1)")	if (whiptail --title "PiNode-XMR Grafana Monitoring" --yesno "This installs Grafana monitoring for your Monero node.\n\nGrafana (the dashboard) and Prometheus (the database) are\nchosen separately, so it fits whatever you already run:\n\n  * Everything on THIS device (browse to port 3000)\n  * Database here - you already have Grafana elsewhere\n  * Grafana here - you already have a database elsewhere\n  * Neither - just report metrics to a stack elsewhere\n\nYour node, blockchain and existing settings are not modified.\n\nWould you like to continue?" 22 78); then
			if get_monitoring_repo; then
				clear
				sudo bash "${MONITORING_DIR}/install.sh"
				echo
				read -n 1 -s -r -p "Press any key to return to the PiNode-XMR menu..."
			fi
			else
			sleep 2
			fi
			clear
			. /home/pinodexmr/setup.sh
			;;

	"2)")	if [ -f "${MONITORING_DIR}/install.sh" ]; then
				clear
				sudo bash "${MONITORING_DIR}/install.sh" --status
				echo
				read -n 1 -s -r -p "Press any key to return to the PiNode-XMR menu..."
			else
				whiptail --title "PiNode-XMR Grafana Monitoring" --msgbox "Monitoring is not installed on this device.\n\nChoose 'Install / Reconfigure Monitoring' to set it up." 12 78
			fi
			clear
			. /home/pinodexmr/setup.sh
			;;

	"3)")	if (whiptail --title "PiNode-XMR Grafana Monitoring" --yesno "This will download the latest version of the monitoring add-on and re-apply it using your current settings.\n\nYour configuration is preserved.\n\nWould you like to continue?" 14 78); then
				if get_monitoring_repo; then
					clear
					sudo bash "${MONITORING_DIR}/install.sh" --unattended
					echo
					read -n 1 -s -r -p "Press any key to return to the PiNode-XMR menu..."
				fi
			else
			sleep 2
			fi
			clear
			. /home/pinodexmr/setup.sh
			;;

	"4)")	if (whiptail --title "PiNode-XMR Grafana Monitoring" --yesno "This will remove the monitoring add-on from this device.\n\nYour Monero node, blockchain data and PiNode-XMR settings are NOT affected.\n\nWould you like to continue?" 14 78); then
				if [ -f "${MONITORING_DIR}/uninstall.sh" ]; then
					clear
					sudo bash "${MONITORING_DIR}/uninstall.sh"
					echo
					read -n 1 -s -r -p "Press any key to return to the PiNode-XMR menu..."
				else
					whiptail --title "PiNode-XMR Grafana Monitoring" --msgbox "The monitoring add-on does not appear to be installed." 10 78
				fi
			else
			sleep 2
			fi
			clear
			. /home/pinodexmr/setup.sh
			;;

	"5)")	whiptail --title "PiNode-XMR Grafana Monitoring" --msgbox "Grafana Monitoring for PiNode-XMR\n\nCollects 39 metrics from your node's RPC — sync status,\npeers, mempool, difficulty, block details, disk and SoC\ntemperature — and charts them on a prepared dashboard.\n\nFour deployment options (dashboard and database are\nchosen separately):\n\n FULL:    Grafana + Prometheus on this device. Browse to\n          http://<this-device>:3000, no import needed.\n BACKEND: Database here; add it to your existing Grafana.\n VIEWER:  Grafana here; reads your existing database\n          (Prometheus, VictoriaMetrics, Mimir...).\n AGENT:   This device only reports. Push works from\n          behind NAT with no ports opened.\n\nFull documentation:\n${MONITORING_REPO}" 26 78
			clear
			. /home/pinodexmr/setupMenuScripts/setup-grafana-monitoring.sh
			;;

	"6)")	clear
			. /home/pinodexmr/setup.sh
			;;

	*)		clear
			. /home/pinodexmr/setup.sh
			;;
esac
