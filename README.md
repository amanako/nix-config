## Word of warning
Be sure to follow each step in given order for config to work.\
Some files contain comments to further customize any options
i considered useful, so be sure to check them out.\
Thanks for reading!

## Build steps

1. Setup environment (If applicable)
```
nix-shell -p git
```

2. Clone the repository

```
git clone https://github.com/shizumu-iruka/nix-config && cd nix-config
```

3. *Optional - If you skip, skip step 4. as well*
    1. Remove current configuration or
    2. Backup current configuration

```
sudo rm -r /etc/nixos 
```
**OR**
    
```
sudo mv /etc/nixos /etc/nixos.bak
```

4. **Important** Generate your own hardware configuration
```
nixos-generate-config --dir .
# Stripe configuration as it's already included
rm configuration.nix 
mv hardware-configuration.nix nixos/hardware-configuration.nix
```

4. Create a symlink to `/etc/nixos/` for `sudo`-less file editing
```
sudo ln ~/path-to-config /etc/nixos
```

5. Rebuild
```
sudo nixos-rebuild switch 
```
