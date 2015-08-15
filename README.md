Taeyeon's custom aports
=======================

This repository contains a number of custom build scripts for [![Alpine Linux][alpine-logo]][alpine]

[alpine]: https://alpinelinux.org
[alpine-logo]: http://pkgs.alpinelinux.org/assets/alpinelinux-logo.svg

Changes to official packages
----------------------------
* BIND
 - Enable GSS API support (--with-gssapi)
* MPD (Music Player Daemon)
 - Build with support for FFmpeg
 - Build with support for pulseaudio
* PulseAudio
 - Alternative version to package in testing

New packages
------------
* ntp :: [The Network Time Protocol reference implementation][ntp]
 - Supports signed ntp (Required for Samba4 Active Directory)
* patchelf :: [A tool for modifying ELF executables][patchelf]
* glibc-runtime :: A package with [libc6][deb-libc6], [libgcc1][deb-libgcc1] and [libstdc++6][deb-libstdc++6] from Debian Jessie
 - Useful for running proprietary binary blobs that bring everything except libc & co
 - Should be treated as a last resort!
* plex-media-server :: [Plex][plex]'s solution to share your content throughout the household and beyond
 - Proprietary blob
 - Uses glibc-runtime
* pulseaudio-shm :: PulseAudio build with the global SHM protection disabled
 - Only EVER use if you know what you're doing.
 - Don't go crying to the devs if it breaks, they'll kill you for even attempting this.
 - You've been warned.

[ntp]: http://ntp.org
[patchelf]: https://nixos.org/patchelf.html
[deb-libc6]: https://packages.debian.org/jessie/libc6
[deb-libgcc1]: https://packages.debian.org/jessie/libgcc1
[deb-libstdc++6]: https://packages.debian.org/jessie/libstdc++6
[plex]: https://plex.tv

apply-upstream.sh
-----------------
This is a useful script I came up with to import commits to modified packages
from upstream aports.

It streamlines creating (format-patch) and applying (am) git patches,
as well as trying to help with conflict resolution should the need arise.
This script in particular is only useful for aports, but similar approaches
could be taken in comparable situations. Do whatever you want with it.

