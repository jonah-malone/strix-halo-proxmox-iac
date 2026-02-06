# IAC for Proxmox on Strix Halo

### Overview

This repo bootstraps a fresh Proxmox installation on Strix Halo. It handles host configuration, guest initalization, and the fiddly little stuff that will implode your host if done incorrectly. 
It only took me two full re-installs of Proxmox to get right! 

This guide draws heavily from kyuz0's [Strix Halo Toolboxes](https://github.com/kyuz0) repositories and began with a fork of Paolo Mainardi's [Framework Desktop Ansible playbook](https://github.com/paolomainardi/framework-desktop-proxmox-iac/tree/main).

I consider the Strix Halo Toolboxes a hard dependency - without them this repo can get you to a functioning VM with iGPU passthrough, but no further. Alternatively, you can modify configure-host-deps.sh #todo



