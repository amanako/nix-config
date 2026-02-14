1. Setup environment (If applicable)
```
nix-shell -p git
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

4. **Important** Generate your own hardware configuration
```
nixos-generate-config --dir . 
rm configuration.nix 
mv hardware-configuration.nix nix-config/nixos/hardware-configuration.nix
```

4. Create a symlink to `/etc/nixos/` for `sudo`-less file editing
```
sudo ln -s nixos-config /etc/nixos
```

5. Rebuild
```
sudo nixos-rebuild switch 
```
