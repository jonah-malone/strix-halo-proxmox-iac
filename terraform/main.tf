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

  on_boot = false # warmup procedure must run before VM start

  agent {
    enabled = true
    type    = "virtio"
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

  # Fedora ISO (cdrom) — uncomment when creating a new VM
  # disk {
  #   datastore_id = "local"
  #   interface    = "ide2"
  #   file_id      = proxmox_virtual_environment_download_file.fedora_iso.id
  #   size         = 3
  # }

  # Main disk
  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = local.config.vm.disk_gb
    discard      = "on"
    iothread     = true
  }

  # Network
  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }

  # GPU passthrough
  hostpci {
    device   = "hostpci0"
    id       = local.config.gpu.pci_id
    pcie     = true
    rom_file = "vbios_1002_1586.bin"
    rombar   = true
    xvga     = true
  }

  # Audio controller passthrough
  hostpci {
    device   = "hostpci1"
    id       = local.config.gpu.audio_pci_id
    pcie     = true
    rom_file = "AMDGopDriver.rom"
    rombar   = true
  }

  #boot_order = ["scsi0", "ide2", "net0"]
  boot_order = ["scsi0", "net0"]
}