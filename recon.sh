#!/bin/bash

# ===== Colors =====
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

if [ $# -eq 0 ]; then
    echo -e "${RED}Usage:${RESET} ./recon.sh target1 target2 target3"
    exit 1
fi

# ===== Typing Animation =====
typing_banner() {
    clear
    echo -ne "${GREEN}"
    text="Initializing Recon Toolkit..."
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep 0.03
    done
    echo ""
    text2="System Ready."
    for (( i=0; i<${#text2}; i++ )); do
        echo -ne "${text2:$i:1}"
        sleep 0.03
    done
    echo -e "\n${RESET}"
    sleep 0.5
}

typing_banner

scan_target() {

    TARGET=$1
    OUTPUT=""

    echo -e "${CYAN}======================================${RESET}"
    echo -e "${YELLOW}Scanning:${RESET} $TARGET"
    echo -e "${CYAN}======================================${RESET}"

    OUTPUT+="======================================\n"
    OUTPUT+="Recon Report for: $TARGET\n"
    OUTPUT+="Generated on: $(date)\n"
    OUTPUT+="======================================\n\n"

    # WHOIS
    echo -e "${BLUE}[+] WHOIS${RESET}"
    WHOIS_RESULT=$(whois $TARGET 2>/dev/null | head -n 15)
    echo "$WHOIS_RESULT"
    OUTPUT+="----- WHOIS -----\n$WHOIS_RESULT\n\n"

    # DNS
    echo -e "${BLUE}[+] DNS Records${RESET}"
    DNS_RESULT=$(dig $TARGET ANY +short)
    echo "$DNS_RESULT"
    OUTPUT+="----- DNS RECORDS -----\n$DNS_RESULT\n\n"

    # Ping
    echo -e "${BLUE}[+] Ping${RESET}"
    PING_RESULT=$(ping -c 2 $TARGET 2>&1)
    echo "$PING_RESULT"
    OUTPUT+="----- PING -----\n$PING_RESULT\n\n"

    # Port Scan
    echo -e "${BLUE}[+] Port Scan${RESET}"
    if command -v nmap &>/dev/null; then
        PORT_RESULT=$(nmap -F $TARGET)
    else
        PORT_RESULT=""
        for port in 21 22 25 53 80 110 139 143 443 445 3306 8080; do
            timeout 1 bash -c "</dev/tcp/$TARGET/$port" 2>/dev/null &&
            PORT_RESULT+="Port $port OPEN\n"
        done
    fi

    echo -e "$PORT_RESULT"
    OUTPUT+="----- PORT SCAN -----\n$PORT_RESULT\n"
    OUTPUT+="\n===== END OF REPORT =====\n"

    # Ask to Save
    echo ""
    read -p "Do you want to save this report? (y/n): " choice

    if [[ "$choice" =~ ^[Yy]$ ]]; then
        mkdir -p recon_results
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        FILE="recon_results/${TARGET}_$TIMESTAMP.txt"
        echo -e "$OUTPUT" > "$FILE"
        echo -e "${GREEN}Report saved to:${RESET} $FILE"
    else
        echo -e "${YELLOW}Report not saved.${RESET}"
    fi

    echo ""
}

# ===== Loop Targets =====
for target in "$@"; do
    scan_target "$target"
done

echo -e "${CYAN}========== ALL SCANS COMPLETE ==========${RESET}"
