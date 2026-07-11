# Secure boot setup

While admittedly it is possible to use `autoGenerateKeys` and `autoEnrollKey` options,
I only faced trouble and following this guide should be a one-time setup anyway.

With the way secure boot is currently setup, following needs to be done:

- Boot to firmware(BIOS likely) and clear keys via _restart to setup mode_ or something in line with that.
It is likely under tab named _security_ or similar.
- Run:

```
# Create keys in /var/lib/sbctl
sudo sbctl create-keys

# Enroll keys with --microsoft flag recommended
sudo sbctl enroll-keys --microsoft --firmware-builtin

# Sign limine boot entry to be able to boot to it
sudo sbctl sign /boot/efi/limine/BOOTX64.EFI

# Reboot
reboot
```

If anything fails try the following:

- Secure boot failures in BIOS: Apply previously mentioned setup mode in bios. Retry.
- Keys don't get recognized: Temporarily remove `wantsSecureBootSupport` host option (if opted in as specified in [file](./secure-boot.nix)),
run `sbctl reset`, rebuild and remove `/var/lib/sbctl`(for non-ephemeral users). Reboot and retry.
