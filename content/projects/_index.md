---
description: "Project section where I share the projects I've done over the past years and my current work"
---

## Welcome to my humble project hub!

Hello there! This section is dedicated to show my humble *open-source* collaboration. 

I enjoy working on side projects that either looks fun to do, it is an interesting topic I wanted to explore or just because. 

The following list are the current **public** projects I've done:

- [dotfiles](https://github.com/salorak/dotfiles.git): A simple bash script to configure (and link) all my configurations files. It also contains my current configuration files.
- [salorak-configuration-files](https://github.com/salorak/salorak-config-files.git): A previous version of my dotfiles where I created bash scripts to configure and install any dependencies of each configuration files. It also contains some useful scripts such as a VPN selector to choose between [HackTheBox](https://hackthebox.com) and [TryHackMe](https://tryhackme.com) openvpn files. Feel free to check it out!
- [cursed-matrix](https://github.com/salorak/cursed-matrix.git): A simple matrix effect written in C using the ncurses library, thus the name. It is not finished but it works relatively well on Linux machines. 


### [dotfiles](https://github.com/salorak/dotfiles.git)
This project takes  HEAVY inspiration on [tsoding](https://twitch.tv/tsoding) bash [script](https://github.com/rexim/dotfiles/blob/master/deploy.sh) to configure his dotfiles. The script is quite easy as it only loops over a MANIFEST, a file containing a table with the path to dotfiles and the destination path, and configures everything.

The main differences with *tsoding* script are the following:
1. I pretty much overengineer'd the MANIFEST to make it look more human readable.
2. Added a backup support, where it allows to use the my configuration files and revert the changes at any time. Do not do it with directories!
3. Added arguments to allow versatility.

Oh! And it contains my **current** configuration files. Take a look at it, you will be surprised I joined both worlds: Emacs and Nvim. 

### [salorak-config-files](https://github.com/salorak/salorak-config-files.git)
My previous configuration git repository. This was my ~~first~~ attempt to unify my configuration files and create a personal installer.

It contains a LOT of work over the commits. I did not want to remove it as it contains a part of me.

One of the things I did was create a bash script to install each package I had in my machine along with some system utilities (such as xclip). When I realized I did not want to execute 10 scripts manually I created the [full_install.sh](https://github.com/SalOrak/Salorak-config-files/blob/main/Configurations/full_install.sh) to chain all the scripts in the correct order. If you want to have my previous setup, just run the script and watch how your Ubuntu (yes, I use Ubuntu) changes its shape completely.

### [cursed-matrix](https://github.com/salorak/cursed-matrix.git)
A simple matrix effect written in C using the [ncurses](https://invisible-island.net/ncurses/ncurses.html) library.

I've been using many guides, packages, plugins, applications, utilities and public forks over the years. This project is a naive attempt to give something out there. It is simple, basic but it kinda does the job. 

