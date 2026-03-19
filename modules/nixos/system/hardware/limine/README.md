# Limine setup

**Note that without this setup old bootloader with previous entries will likely start preventing you from booting to new generations**.

<h3> This can either be done: </h3>
<hr>

<details>
<summary>In bios (RECOMMENDED)</summary>

1. Reboot to firmware.
```
systemctl --reboot --firmware-setup
```
(It is also included in the config as an alias `bios`)  
2. Look for an option named _boot_ or alike in the menu and swipe the limine entry to top.

</details>

*OR*

<details>
<summary> With `efibootmgr` utility </summary>

1. Enter a temporary shell with `efibootmgr`.
```
nix-shell -p efibootmgr
```
2. List entries
```
efibootmgr --verbose
```
3. Look at `BootOrder` section and note limine entry in the list in form of 4 digits, usually 000x.
4. Swap out boot order and activate limine entry.
```
sudo efibootmgr -o <limine entry>,000a,000b,000c,...000z -A -b <limine entry>
```
where `a,b,c,...,z` are other boot entry numbers.
</details>
<hr>

You may reboot afterwards and limine should be booted with newly built generation.
