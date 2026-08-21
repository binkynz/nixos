# Placeholder — regenerate on the target machine:
#   nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# Or let install.sh generate it for you.
{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
}
