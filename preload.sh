#!/bin/bash
echo "Running preload.sh"

# Function to check if Ollama is installed and if llava:v1.6 is installed
function check_ollama_installed {
    if command -v ollama &> /dev/null
    then
        echo "Ollama is already installed"
        if ollama list | grep -q "llava:v1.6"
        then
            echo "Llava:v1.6 already installed"
            return 0
        else
            echo "Llava:v1.6 is not installed"
            return 1
        fi
    else
        echo "Ollama is not installed"
        return 2
    fi
}

# Function to install Ollama on Linux
function install_ollama_linux {
    sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/bin/ollama
    sudo chmod +x /usr/bin/ollama
}

# Function to install Ollama on macOS
function install_ollama_macos {
    sudo curl -L https://ollama.com/download/ollama-darwin-amd64 -o /usr/local/bin/ollama
    sudo chmod +x /usr/local/bin/ollama
}

# Function to add Ollama as a startup service on Linux
function setup_service_linux {
    sudo useradd -r -s /bin/false -m -d /usr/share/ollama ollama
    echo "[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/ollama.service

    sudo systemctl daemon-reload
    sudo systemctl enable ollama
}

# Function to add Ollama as a startup service on macOS
function setup_service_macos {
    sudo defaults write /Library/LaunchDaemons/com.ollama.ollama.plist Label -string "com.ollama.ollama"
    sudo defaults write /Library/LaunchDaemons/com.ollama.ollama.plist ProgramArguments -array "/usr/local/bin/ollama" "serve"
    sudo defaults write /Library/LaunchDaemons/com.ollama.ollama.plist RunAtLoad -bool true
    sudo chown root:wheel /Library/LaunchDaemons/com.ollama.ollama.plist
}

# Detect the operating system and install Ollama if necessary
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    check_ollama_installed
    status=$?
    if [ $status -eq 2 ]; then
        install_ollama_linux
        setup_service_linux
        sudo systemctl start ollama
    fi
    if [ $status -ne 0 ]; then
        ollama pull llava:v1.6
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    check_ollama_installed
    status=$?
    if [ $status -eq 2 ]; then
        install_ollama_macos
        setup_service_macos
        sudo launchctl load /Library/LaunchDaemons/com.ollama.ollama.plist
    fi
    if [ $status -ne 0 ]; then
        ollama pull llava:v1.6
    fi
else
    echo "Unsupported OS. Please install Ollama manually."
    exit 1
fi