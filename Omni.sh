#!/bin/bash

# Omni - A Comprehensive Linux Privilege Escalation Scanner (Offline-First)
# Author: Cillia
# Features: SUID, SGID, Writable Files & Offline GTFOBins Support (no jq)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Set paths
GTFOLIST="/tmp/gtfobins.json"
OFFLINE_GTFOLIST="./gtfobins-offline.json"

# ASCII Banner
cat << "EOF"

                                ...',;;:cccccccc:;,..
                            ..,;:cccc::::ccccclloooolc;'.
                         .',;:::;;;;:loodxk0kkxxkxxdocccc;;'..
                       .,;;;,,;:coxldKNWWWMMMMWNNWWNNKkdolcccc:.
                    .',;;,',;lxo:...dXWMMMMMMMMNkloOXNNNX0koc:coo;.
                 ..,;:;,,,:ldl'   .kWMMMWXXNWMMMMXd..':d0XWWN0d:;lkd,
               ..,;;,,'':loc.     lKMMMNl. .c0KNWNK:  ..';lx00X0l,cxo,.
             ..''....'cooc.       c0NMMX;   .l0XWN0;       ,ddx00occl:.
           ..'..  .':odc.         .x0KKKkolcld000xc.       .cxxxkkdl:,..
         ..''..   ;dxolc;'         .lxx000kkxx00kc.      .;looolllol:'..
        ..'..    .':lloolc:,..       'lxkkkkk0kd,   ..':clc:::;,,;:;,'..
        ......   ....',;;;:ccc::;;,''',:loddol:,,;:clllolc:;;,'........
            .     ....'''',,,;;:cccccclllloooollllccc:c:::;,'..
                    .......'',,,,,,,,;;::::ccccc::::;;;,,''...
                      ...............''',,,;;;,,''''''......
                           ............................

EOF

echo -e "${YELLOW}[+] Omni: Starting Privilege Escalation Scan${NC}"

# Download GTFOBins or use local copy
if command -v curl &>/dev/null && ping -c 1 github.com &>/dev/null; then
    echo -e "${YELLOW}[+] Omni: Downloading latest GTFOBins database...${NC}"
    curl -s https://gtfobins.github.io/gtfobins.json  -o "$GTFOLIST"
    GTFOSOURCE="$GTFOLIST"
else
    if [[ -f "$OFFLINE_GTFOLIST" ]]; then
        echo -e "${YELLOW}[+] Omni: Using offline GTFOBins database...${NC}"
        GTFOSOURCE="$OFFLINE_GTFOLIST"
    else
        echo -e "${YELLOW}[-] Omni: No internet or offline GTFOBins file found.${NC}"
        exit 1
    fi
fi

# Function to scan SUID/SGID binaries
scan_binaries() {
    local mode=$1
    local perm=$2
    echo -e "${YELLOW}[+] Omni: Scanning for $mode binaries...${NC}"
    local BINARIES=$(find / -perm "$perm" -type f 2>/dev/null)

    for BINARY in $BINARIES; do
        BINARY_NAME=$(basename "$BINARY")
        
        if [[ ! -f "$BINARY" || ! -x "$BINARY" ]]; then
            continue
        fi

        echo -e "${GREEN}[!] Found $mode Binary:${NC} $BINARY"
        
        # Check if binary exists in GTFOBins list
        if grep -q "\"name\": \"$BINARY_NAME\"" "$GTFOSOURCE"; then
            echo -e "${YELLOW}Capabilities:${NC}"

            # Extract categories manually
            grep -A 5 "\"categories\": \[" "$GTFOSOURCE" | awk "/\"$BINARY_NAME\"/,/]/" | grep -v '^{' | sed -n '/\[/,$p' | tr -d '],' | grep -v '^\s*$' | head -n 5 | sed 's/^/  /'

            echo -e "${YELLOW}Example Commands:${NC}"

            # Extract examples manually
            grep -A 10 "\"examples\": \"" "$GTFOSOURCE" | awk "/\"$BINARY_NAME\"/,/\"/" | grep -A 1 '"examples": "' | tail -n +2 | sed 's/"//g;s/,//' | sed 's/^/  /'
        fi
        echo "----------------------------------------"
    done
}

# Function to scan writable files
scan_writable_files() {
    echo -e "${YELLOW}[+] Omni: Scanning for World-Writable Files/Directories...${NC}"
    find / -type f -perm -o=w 2>/dev/null | grep -v "^/proc" | head -n 20 | while read -r file; do
        echo -e "${GREEN}[!] World-Writable File:${NC} $file"
    done

    find / -type d -perm -o=w 2>/dev/null | grep -v "^/proc" | head -n 20 | while read -r dir; do
        echo -e "${GREEN}[!] World-Writable Directory:${NC} $dir"
    done
}

# Run scans
scan_binaries "SUID" "-u=s"
scan_binaries "SGID" "-g=s"
scan_writable_files

# Cleanup
[[ -f "$GTFOLIST" ]] && rm -f "$GTFOLIST"
