# Smart Recon Tool

A simple Bash-based reconnaissance tool for educational and penetration testing practice.

## Description

Smart Recon Tool allows you to scan one or multiple targets from the terminal.  
It performs:

- WHOIS lookup
- DNS record lookup
- Ping test
- Port scanning (uses Nmap if available)

The tool can also save reports with timestamps.

## Installation

Clone the repository:

```bash
git clone https://github.com/ESPECTROFEDERAL/Smart-Recon-Tool.git
cd Smart-Recon-Tool
chmod +x recon.sh
```
USAGE
Scan a single target:
```
./recon.sh example.com
```
Scan multiple targets:
```
./recon.sh example.com google.com github.com
```
Reports (if saved) are stored in the recon_results/ folder.

Requirements

Linux (Kali Linux recommended)

Bash

whois

dig

nmap (optional)

Disclaimer

This tool is for educational purposes only.

