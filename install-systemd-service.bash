#!/bin/bash

# This script is derived from another's work
# Credit: Uli Köhler - https://techoverflow.net Licensed as CC0 1.0 Universal
SERVICE_NAME=web-director


script_dir="$(dirname "$(readlink -f "$0")")"
compose_bin="$(which podman-compose)"

echo "Creating systemd service... /etc/systemd/system/${SERVICE_NAME}.service"
# Create systemd service file
service_file_contents=$(cat <<EOF
[Unit]
Description=$SERVICE_NAME
Requires=podman.service
After=podman.service

[Service]
Restart=always
User=root
Group=root
WorkingDirectory=${script_dir}
# Shutdown container (if running) when unit is started
ExecStartPre=${compose_bin} down
ExecStart=${compose_bin} up
ExecStop=${compose_bin} down

[Install]
WantedBy=multi-user.target
EOF
)

echo "${service_file_contents}" | sudo tee "/etc/systemd/system/${SERVICE_NAME}.service"

sudo systemctl daemon-reload

echo "Enabling & starting ${SERVICE_NAME}"
# Autostart systemd service
sudo systemctl enable --now "${SERVICE_NAME}.service"
