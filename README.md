Taeyeon's custom aports
=======================

This repository contains a number of custom build scripts for [![Alpine Linux][alpine-logo]][alpine]

[alpine]: https://alpinelinux.org
[alpine-logo]: http://pkgs.alpinelinux.org/assets/alpinelinux-logo.svg

Changes to official packages
----------------------------
* BIND
 - Enable building with support for Linux capabilities (no --disable-linux-caps)
* MPD (Music Player Daemon)
 - Build with support for FFmpeg
 - Build with support for pulseaudio
* PulseAudio
 - Resurrected from unmaintained
 - Updated to v6.0

New packages
------------
* ntp :: [The Network Time Protocol reference implementation][ntp]
* patchelf :: [A tool for modifying ELF executables][patchelf]
* glibc-runtime :: A package with [libc6][deb-libc6], [libgcc1][deb-libgcc1] and [libstdc++6][deb-libstdc++6] from Debian Jessie
 - Useful for running proprietary binary blobs that bring everything except very low-level system libraries
 - Should be treated as a last resort!
* plex-media-server :: [Plex][plex]'s solution to share your content throughout the household and beyond
 - Proprietary blob
 - Uses glibc-runtime

[ntp]: http://ntp.org
[patchelf]: https://nixos.org/patchelf.html
[deb-libc6]: https://packages.debian.org/jessie/libc6
[deb-libgcc1]: https://packages.debian.org/jessie/libgcc1
[deb-libstdc++6]: https://packages.debian.org/jessie/libstdc++6
[plex]: https://plex.tv

