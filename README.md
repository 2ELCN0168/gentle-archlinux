# Gentle Archlinux Installer

![Cast](assets/gentle-arch.cast.gif)

This script is an automated installation of Archlinux.
As I don't like that much the official "archinstall" script, I decided to do my own.

It contains much more customizations like pacman hooks, configured DNS, LUKS encryption, TTY themes, and more.

It detects if you're booting in UEFI or BIOS mode, and adjusts its questions automatically.

## How to install

First, you need an Internet connection. If you have a wired connection, it should already be set up. Otherwise, you have to configure it with `iwctl` or `networkctl`.

```bash
pacman-key --init
pacman-key --populate archlinux
pacman -Sy git
git clone https://github.com/2ELCN0168/gentle-archlinux
cd gentle-archlinux
./Archlinux_Gentle_Installer.sh
```

## Parameters

- **_-e :_** Enable hardening mode ;
- **_-c :_** Full detailed installation with complete customizations options ;
- **_-m :_** Minimal installation _(Fast with default options)_.

## What it contains

**_Support for BIOS/UEFI mode_**
**_Support for different bootloaders :_**

- _rEFInd ;_
- _GRUB ;_
- _systemd-boot._

**_Support diverse filesystems :_**

- _XFS ;_
- _EXT4 ;_
- _BTRFS._

**_Support logical volumes by:_**

- _LVM (One or multiple disks) ;_
- _BTRFS subvolumes._

**_Support for different network manager :_**

- _NetworkManager ;_
- _systemd-networkd._

**_Support for LUKS encrypted partition ;_**
**_Auto-install microcode based on CPU vendor detection ;_**
**_(Choice) - Guest agent for VM installations ;_**
**_(Choice) - Networking tools ;_**
**_(Choice) - Monitoring tools ;_**
**_(Choice) - Helping tools ;_**
**_sshguard/nftables installation ;_**
**_Lock/Unlock root account ;_**
**_Custom vim/neovim configuration files (Basic, suitable for server use) ;_**
**_Custom initcpio based on choices ;_**
**_ZSH + basic plugins for it ;_**
**_Choices for country timezone or keymap ;_**
**_Choices and recommendations for username/hostname/domain-name ;_**
**_Custom .zshrc and .bashrc ;_**
**_Custom TTY themes ;_**
**_Custom motd/issue script ;_**
**_Custom systemd services/timers ;_**
**_Custom environment variables and aliases/functions (+colored output of some commands like lsblk, ping, blkid, traceroute, etc.) ;_**
**_Support for different desktop environments (-c parameter only) ;_**
**_Hardening mode based on ANSI recommendations (Work in progress) ;_**
**_Post-installation scripts for the user ;_**

And a bit more than that but I don't find it useful to write it there.

## Issues

mmcblk devices are not supported actually.

## TODO

- [x] - Generate zshrc ;
- [x] - Ask for additionnal packages ;
- [x] - nftables + sshguard ;
- [x] - pacman hooks ;
- [ ] - pacman hook for archlinux news (informant) ;
- [ ] - pacdiff ;
- [x] - motd et issue.net ;
- [ ] - Conditions LVM ;
- [x] - Repair f_partition_disks.sh ;
- [x] - Remake the formatting and LVM part to eliminate duplicate or non-pratical code ;
- [ ] - Add mmcblk disk type support ;
- [ ] - Add support for swapfile/swap/zram ;
- [ ] - Add hardening mode ;
- [x] - Adapt sudoers.d config, enable insults, change $SUDO_PROMPT ;
- [x] - Regex to check username/hostname validity ;
