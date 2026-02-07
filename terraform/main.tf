locals {
  config = yamldecode(file("../config/infrastructure.yml"))
}

resource "proxmox_virtual_environment_download_file" "fedora_iso" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = local.config.proxmox.node
  url          = local.config.vm.iso_url
}

resource "proxmox_virtual_environment_vm" "fedora" {
  node_name = local.config.proxmox.node
  vm_id     = local.config.vm.id
  name      = local.config.vm.name

  agent {
    enabled = true
  }

  bios    = "ovmf"
  machine = "q35,viommu=virtio"

  cpu {
    cores   = local.config.vm.cores
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = local.config.vm.memory_mb
  }

  operating_system {
    type = "l26"
  }

  scsi_hardware = "virtio-scsi-single"

  # EFI disk
  efi_disk {
    datastore_id      = "local-lvm"
    type              = "4m"
    pre_enrolled_keys = true
  }

  # Main disk
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = local.config.vm.disk_gb
    discard      = "on"
    iothread     = true
  }

  # Fedora ISO
  cdrom {
    enabled   = true
    file_id   = proxmox_virtual_environment_download_file.fedora_iso.id
    interface = "ide2"
  }

  # Network
  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }

  # GPU passthrough
  hostpci {
    device   = local.config.gpu.pci_id
    pcie     = true
    rom_file = "vbios_1002_1586.bin"
  }

  # Audio controller passthrough
  hostpci {
    device   = local.config.gpu.audio_pci_id
    pcie     = true
    rom_file = "AMDGopDriver.rom"
  }

  boot_order = ["scsi0", "ide2", "net0"]
}