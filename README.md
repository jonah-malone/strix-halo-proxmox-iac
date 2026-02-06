# IAC for Proxmox on Strix Halo

### Overview

This repo bootstraps a fresh Proxmox installation on Strix Halo with **working iGPU passthrough**. It handles host configuration, guest initalization, and the fiddly little stuff that will implode your host if done incorrectly. 
It only took me two full re-installs of Proxmox to get right! 

This guide draws heavily from kyuz0's [Strix Halo Toolboxes](https://github.com/kyuz0) repositories and began with a fork of Paolo Mainardi's [Framework Desktop Ansible playbook](https://github.com/paolomainardi/framework-desktop-proxmox-iac/tree/main). I consider the Strix Halo Toolboxes a hard dependency - without them this repo can get you to a functioning VM with iGPU passthrough, but no further. Alternatively, you can modify configure-host-deps.sh #todo

### Prerequisites
- Proxmox VE installed on host
- BIOS 3.3 or newer *on Framework Desktop/Mainboard (other manufacturers may vary)*


### Limitations and Current State

- I haven't validated GRUB boot - my system uses systemd 

### FAQ

##### "How do I update my Framework Mainboard BIOS?"
- I used `fwupdmgr` of which `udisks2` is a dependency
- Run `apt install udisks2 && apt install fwupd` and update as follows: 
  - `fwupdmgr refresh --force \ fwupdmgr get-updates \ fwupdmgr update`
  - If this doesn't work, you may have hit the same bug I did where `fwupdmgr` reported no available updates despite newer BIOS versions being availabile in their repository. It seems to be because of a bug, where `fwupd` checks `bios-vendor` instead of `system-manufacturer`.
- If you experience this bug, pull the updated BIOS directly with `wget` and run `fwupdmgr` directly: 
    ```bash
    wget repourl.whatever
    mv "long-ass-name.cab" "short-name.cab"
    fwupdmgr install short-name.cab
    ```



