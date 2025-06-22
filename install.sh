#!/data/data/com.termux/files/usr/bin/bash

# Colors
G="\e[32m"; R="\e[31m"; Y="\e[33m"; C="\e[36m"; W="\e[0m"

echo -e "${C}╔═══════════════════════════════════════╗"
echo -e "║   🌐 Installing WEBSITE Scanner Suite  ║"
echo -e "╚═══════════════════════════════════════╝${W}"

# Step 1: Install packages
echo -e "${Y}[+] Checking for required packages...${W}"
pkg update -y && pkg upgrade -y
pkg install git php curl wget jq nmap python2 nano -y

# Step 2: Clone RED HAWK
if [ ! -d "$HOME/RED_HAWK" ]; then
  echo -e "${Y}[+] Cloning RED HAWK...${W}"
  git clone https://github.com/Tuhinshubhra/RED_HAWK.git $HOME/RED_HAWK
else
  echo -e "${G}[✓] RED HAWK already installed.${W}"
fi

# Step 3: Clone fsociety
if [ ! -d "$HOME/fsociety" ]; then
  echo -e "${Y}[+] Cloning fsociety...${W}"
  git clone https://github.com/Manisso/fsociety.git $HOME/fsociety
else
  echo -e "${G}[✓] fsociety already installed.${W}"
fi

# Step 4: Create the WEBSITE launcher
echo -e "${Y}[+] Creating global launcher: WEBSITE${W}"

cat > $PREFIX/bin/WEBSITE << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

G="\e[32m"; R="\e[31m"; Y="\e[33m"; C="\e[36m"; W="\e[0m"
clear
echo -e "${C}"
echo "╔═══════════════════════════════════════╗"
echo "║       🌐 WEBSITE SCANNER SUITE        ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${W}"

echo -e "${Y}[1] RDAP WHOIS (Clean View)"
echo -e "[2] RED HAWK"
echo -e "[3] Subdomain Scanner"
echo -e "[4] Nmap Port Scan"
echo -e "[5] SQLi Scan (Red Hawk)"
echo -e "[6] CMS Detector"
echo -e "[7] fsociety (Python2)"
echo -e "[Q] Quit${W}"

read -p $'\n[?] Choose an option: ' opt

case "$opt" in
  1)
    read -p "[+] Enter domain (e.g. example.com): " domain
    res=$(curl -s "https://rdap.verisign.com/com/v1/domain/$domain")
    echo -e "\n${G}--- RDAP WHOIS Info for $domain ---${W}"
    echo "Domain        : $(echo "$res" | jq -r '.ldhName')"
    echo "Registrar     : $(echo "$res" | jq -r '.entities[0].vcardArray[1][1][3]')"
    echo "Created On    : $(echo "$res" | jq -r '.events[] | select(.eventAction==\"registration\") | .eventDate')"
    echo "Expires On    : $(echo "$res" | jq -r '.events[] | select(.eventAction==\"expiration\") | .eventDate')"
    echo "Status        : $(echo "$res" | jq -r '.status[]' | tr '\n' ', ')"
    echo "Nameservers   : $(echo "$res" | jq -r '.nameservers[].ldhName' | paste -sd ', ')"
    echo "Abuse Contact : $(echo "$res" | jq -r '.entities[0].entities[0].vcardArray[1][2][3]') / $(echo "$res" | jq -r '.entities[0].entities[0].vcardArray[1][3][3]')"
    ;;
  2)
    cd $HOME/RED_HAWK
    php rhawk.php
    cd
    ;;
  3)
    read -p "[+] Enter domain (e.g. google.com): " dom
    curl -s "https://api.hackertarget.com/hostsearch/?q=$dom"
    ;;
  4)
    read -p "[+] Enter target (IP or domain): " target
    nmap -Pn -T4 "$target"
    ;;
  5)
    cd $HOME/RED_HAWK
    php rhawk.php
    cd
    ;;
  6)
    read -p "[+] Enter domain: " d
    curl -s "https://whatcms.org/APIEndpoint/Detect?key=freekey&url=$d"
    ;;
  7)
    cd $HOME/fsociety
    python2 fsociety.py
    cd
    ;;
  [Qq])
    echo -e "${R}Goodbye!${W}"
    exit 0
    ;;
  *)
    echo -e "${R}Invalid option!${W}"
    ;;
esac
EOF

chmod +x $PREFIX/bin/WEBSITE

# Step 5: Confirm
echo -e "\n${G}[✓] Installed successfully! Type 'WEBSITE' to launch the scanner suite.${W}"
