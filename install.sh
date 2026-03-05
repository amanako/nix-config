#!/bin/sh

max_attempts=3
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

check_sudo_password() {
  attempts=0
  while [ $attempts -lt $max_attempts ]; do
    echo -e "Please enter your ${RED}sudo${RESET} password: "
    read -s password
				
		# Clear cached credentials to ensure freshness
		sudo -k
		# Try to list current directory content to check sudo success
    if echo "$password" | sudo -S ls &>/dev/null; then
			echo -e "${GREEN}Password correct!${RESET}"
      return 0
    else
      attempts=$((attempts + 1))
        read -p "Incorrect password. Try again? (y/n): " exit_choice
        if [[ ! $exit_choice =~ ^[Yy]$ ]]; then
          echo "Exiting..."
          exit 1
        fi
      fi
  done
  echo "Too many incorrect attempts. Exiting..."
  exit 1
}

print_introduction() {
	printf "${YELLOW}If you already have a hardware configuration which \nyou would like to use, move it to ./nixos/hardware-configuration.nix \nbefore proceeding.${RESET}\n---------------------------------------------------------------------------\n${YELLOW}(Exit and check the script if unsure whether to proceed.)${RESET}\n"
}

print_introduction
check_sudo_password

echo -e "${RED}(D)elete${RESET} /etc/nixos/, make ${YELLOW}(b)ackup${RESET} or nothing(default): " 
read location_choice

if [[ $location_choice =~ ^[Dd]$ ]]; then
  echo "Removing /etc/nixos..."
  echo "$password" | sudo rm -r /etc/nixos &>/dev/null
elif [[ $location_choice =~ ^[Bb]$ ]]; then
  echo "Moving /etc/nixos to /etc/nixos.bak..."
  echo "$password" | sudo mv /etc/nixos /etc/nixos.bak
else
	echo "Skipping..."
fi

echo -e "${RED}IMPORTANT:${RESET} IF UNSURE CHOOSE ${GREEN}y${RESET}"
read -p "Generate hardware-configuration.nix? (y/n): " config_choice
if [[ $config_choice =~ ^[Yy]$ ]]; then
  echo "Generating config..."
  nixos-generate-config --dir . &>/dev/null
  echo "Removing superfluous configuration.nix..."
  rm configuration.nix
  echo "Copying hardware-configuration.nix to ./nixos/..."
  mv hardware-configuration.nix ./nixos/hardware-configuration.nix
fi

echo -e "Create ${RED}symlink${RESET} to /etc/nixos? (y/n): "
read symlink_choice
if [[ $symlink_choice =~ ^[Yy]$ ]]; then
  echo "Creating symlink to /etc/nixos..."
	echo "$password" | sudo ln -s $(pwd) /etc/nixos
  echo -e "${GREEN}Done! Rebuild with \`sudo nixos-rebuild switch\` from any directory${RESET}"
  exit 0
fi

echo -e "${GREEN}Done! Rebuild with \`sudo nixos-rebuild switch --flake $(pwd)\`${RESET}"
exit 0
