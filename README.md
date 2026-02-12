1. Setup environment
```
mkdir -p ~/Documents/nixos-config && cd ~/Documents/nixos-config
```

2. Clone the repository

```
git clone https://github.com/shizumu-iruka/nix-config
```

3.
    1. Remove current configuration or
    2. Backup current configuration

```
rm -r /etc/nixos/ 
```
**OR**
    
```
sudo mv /etc/nixos /etc/nixos.bak
```

4. Create a symlink to /etc/nixos/ for `sudo`-less file editing
```
sudo ln -s ~/Documents/nixos-config /etc/nixos
```

5. Rebuild
```
sudo nixos-rebuild switch 
```
