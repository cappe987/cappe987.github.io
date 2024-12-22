---
layout: post
title: "Buildroot and U-boot on Raspberry Pi"
date: 2024-12-22
tags: ["linux", "programming"]
categories: linux
description: "
When doing development of the OS, flashing your SD card after every change is
not reasonable. Instead, use U-boot to allow booting over the network. In this
post I go over configuring Buildroot to build U-boot and configure it for a
Raspberry Pi.
"
---

This post guides you through setting up Buildroot together with U-boot
on your Raspberry Pi and loading a kernel through U-boot (rootfs is
separate and still needs to be flashed). Having a dedicated bootloader
allows controlling the boot process without having to flash the SD
card every time. I wrote this post because I didn't find any guide
when doing so myself, only a couple of posts that partially did
it. None of which fully covered my needs. I have a Raspberry Pi 4 and
that's all this guide is tested with.

This guide requires having a serial console connection to the
Raspberry Pi. It also requires having a TFTP server if you wish to
boot over the network.

## Building the image with Buildroot

Start by cloning Buildroot and `cd` into it.

```sh
git clone https://github.com/buildroot/buildroot.git
cd buildroot
```

Next we will select the defconfig corresponding to our board. I'm
using a Raspberry Pi 4b and wish to use the 64-bit version so I pick
this one.

```sh
make raspberrypi4_64_defconfig
```

If you do `ls configs/raspberrypi*` you get a list of all available
versions.

Next we will configure some things with the build system through a
menu.

```sh
make menuconfig
```

1. Go to "Bootloaders" and enable "U-boot". Under the "U-boot"
   section, select "Board defconfig". For the Pi 4 you write `rpi_4`
   here. This is the only required setting for this tutorial, but I
   highly recommend doing the following steps too.
1. Go to "Toolchain > Toolchain Type" and set "External toolchain". This
   allow us to skip building the whole toolchain.
1. Go to "Toolchain > Toolchain" and under "Toolchain External Options"
   header select "Bootlin Toolchains" (my recommendation).
1. Go to "Build options" and select "Enable compiler cache". This will
   improve the build time if you have to do full rebuilds later on.
1. (Optional) Go to "System Configuration > System hostname" and set whatever
   hostname you want.
   
These are the U-boot configs available for Raspberry Pi at the time of writing.

```sh
rpi_defconfig
rpi_0_w_defconfig
rpi_2_defconfig
rpi_3_32b_defconfig
rpi_3_defconfig
rpi_3_b_plus_defconfig
rpi_4_32b_defconfig
rpi_4_defconfig
rpi_arm64_defconfig
```

Note that the `_defconfig` section should not be included when setting
the defconfig for U-boot.

Now we have all required Buildroot settings, but some modifications
are still required to prepare the image correctly.

In the file `board/raspberrypi/config_4_64bit.txt` (or corresponding
file for your version of the Pi) change the line `kernel=Image` to
`kernel=u-boot.bin`. The `config.txt` files configures the built-in
Raspberry Pi bootloader. We're telling it to boot into U-boot instead
of directly to a kernel image.

Because of the change above we now need to make sure the kernel image
is included in the final image too. In the file
`board/raspberrypi/post-image.sh` there is the following line.

```sh
FILES+=( "${KERNEL}" )
```

This is corresponds to the `kernel=` from the previous file, that we
just set to `u-boot.bin`. Below this line, add the line `FILES+=(
"Image" )`.

Now we are ready to build everything. This can take some time. Maybe 20-30 minutes?

```sh
make
```

Once everything is done building there should be a file `output/images/sdcard.img`.


## Flashing the SD card

The command `lsblk` can be used to list all block devices. Insert your
SD card into your computer and you should see it pop up in the
list. For me it's called `mmcblk0`.

To flash the SD card run the following command. Make sure to use the
name of your SD card in place of `mmcblk0`.

> Note: flashing is a destructive operation and will erase everything on the card.

```sh
sudo dd if=output/images/sdcard.img of=/dev/mmcblk0 bs=1M
```

Insert the SD card into your Raspberry Pi and power it on. In the
console you should see some U-boot output popping up. It will attempt
to boot a kernel, but should fail. Before U-boot tries to boot the
kernel there is a 3 second countdown where you can press any key to
stop the boot process if you wish (useful in the next section).

## Configuring U-boot and booting from SD card and network

Enter the following two commands into the console. The first loads the
kernel image into memory. The second boots the image. Now you should
see a message saying "Starting kernel ..." followed by a lot more
output, and finally a login prompt. The default login is the username
`root` with no password. This can be configured in the menuconfig in
the same place as the hostname.

```sh
fatload mmc 0 ${kernel_addr_r} Image
booti ${kernel_addr_r} - ${fdt_addr}
```

Hopefully this booted the kernel for you. Let's take a look at booting
over the network. This requires a TFTP server, and ideally also a DHCP
server. If you don't have a DHCP server you can set static IPs.

```sh
dhcp ${kernel_addr_r} Image
booti ${kernel_addr_r} - ${fdt_addr}
```

```sh
setenv serverip '10.0.0.1'
setenv ipaddr '10.0.0.101'
tftp ${kernel_addr_r} Image
booti ${kernel_addr_r} - ${fdt_addr}
```

Note that any `setenv` we did is gone after rebooting. Run `saveenv`
to preserve it. Next we will set up some commands to make it
automatically boot from flash or network.

```sh
setenv netboot_filename 'Image'
setenv netboot 'dhcp ${kernel_addr_r} ${netboot_filename}; booti ${kernel_addr_r} - ${fdt_addr}'
setenv sdboot 'fatload mmc 0 ${kernel_addr_r} Image; booti ${kernel_addr_r} - ${fdt_addr}'
setenv bootcmd 'run sdboot'
saveenv
```

`bootcmd` decides what is run to attempt booting. We define one
variable for the filename which can be convenient to change when
working with images over the network. The variable `netboot` is the
full command for booting over the network, and `sdboot` is for booting
from SD card. Now `bootcmd` is set to boot from SD card, but we can
easily change it with `setenv bootcmd 'run netboot'`, followed by
`saveenv`, to boot over the network instead.

Keep in mind, if you flash the whole sdcard.img again it will wipe the
U-boot config, as well as any files in the Linux root file system.

As a final step, save your defconfig for later.

```sh
make savedefconfig BR2_DEFCONFIG=configs/my_defconfig
```

I may do a follow up post on some more advanced configuration options.
Some ideas are:
- Modifying partition sizes
- Built-in U-boot environment
- Updating the flashed image from within Linux
- Including a filesystem in the kernel image

<!-- ## Modifying partition sizes -->




<!-- ## Updating the flashed image from within Linux -->

<!-- Mount boot partition mmcblk0p1 and write over Image. -->


<!-- ## Built-in environtment -->

<!-- Keep the u-boot environment even after flashing again. -->





<!-- At the very end. Save the Buildroot defconfig using -->
<!-- ``` -->
<!-- make savedefconfig BR2_DEFCONFIG=./my_defconfig -->
<!-- ``` -->
