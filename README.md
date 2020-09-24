# Compute

iOS application for using a Raspberry Pi as a compute module

## Summary

This project is intended to build on previous work and guides that set about using the [Raspberry Pi](https://www.raspberrypi.org) as an iPad accessory, connecting it over USB-C and then using VNC and SSH to control the Pi. While these solutions are great if your goal is to use a Raspberry Pi, they don't really allow the two systems to interoperate; the iPad essentially acts as a dumb terminal for the Pi; Compute tries to bridge that gap.

Compute uses a WebDAV server to allow the Raspberry Pi to mount the files on the iPad and act on the iPad, making for a much greater seamless integration between the two systems. Ultimately, the goal is to automatically launch the app and configure the connection when the Raspberry Pi is plugged in to the iPad.

## Background

There are some great guides which describe the process of configuring a Raspberry Pi to use the iPad's USB-C connection for networking:

- [Use Raspberry Pi 4 USB-C data connection to connect with iPad Pro](https://magpi.raspberrypi.org/articles/connect-raspberry-pi-4-to-ipad-pro-with-a-usb-c-cable) –  a great guide by [The MagPi](https://magpi.raspberrypi.org/)
- [Pi4 USB-C Gadget](https://www.hardill.me.uk/wordpress/2019/11/02/pi4-usb-c-gadget/)

## Utilities

Utilities for connecting directly to, and managing, your Raspberry Pi:

- [VNC Viewer for iOS](https://www.realvnc.com/en/connect/download/viewer/ios/)
- [Blink Shell](https://blink.sh)
- [Termius for iOS](https://termius.com/ios)

## Alternatives

The goal of Compute is to bring a containerised development environment to the iPad, in the same way that Docker might be used for a build phase both in CI solutions, and locally. In an ideal world, this development environment would be available natively within iOS through a virtualisation layer. There are some projects which attempt to do exactly this, from as far back as 2018:

* [UTM](https://getutm.app) – QEMU-based virtualisation
  * [Installing ArchLinux on an iPad](https://www.youtube.com/watch?app=desktop&v=fsDEei0XS94) (YouTube)
  * [New app to let you run Windows 10 on your iPhone](https://www.windowslatest.com/2020/02/22/iphone-ipad-windows-10/)
* [iSH](https://ish.app) – Linux shell for iOS
  * [How to Get a Linux Shell on iPad or iPhone with iSH](https://osxdaily.com/2018/12/11/ish-linux-shell-ios/)
* [iPad Linux](https://ipadlinux.org) – lists many of the approaches to getting Linux running on an iPad, from virtualisation through to jailbreaking

