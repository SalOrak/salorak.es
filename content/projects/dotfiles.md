+++
title="Dotfiles"
description="A simple bash script to configure (and link) all my configurations files. It also contains my current configuration files."
weight=902
date=2023-08-10

[taxonomies]
tags=["bash","dotfiles"]

[extra]
repo_view=true
repo_url="https://github.com/SalOrak/dotfiles.git"
+++

# Dotfiles

This project takes  HEAVY inspiration on [tsoding](https://twitch.tv/tsoding) bash [script](https://github.com/rexim/dotfiles/blob/master/deploy.sh) to configure his dotfiles. The script is quite easy as it only loops over a MANIFEST, a file containing a table with the path to dotfiles and the destination path, and configures everything.

The main differences with *tsoding* script are the following:
1. I pretty much overengineer'd the MANIFEST to make it look more human readable.
2. Added a backup support, where it allows to use the my configuration files and revert the changes at any time. Do not do it with directories!
3. Added arguments to allow versatility.

Oh! And it contains my **current** configuration files. Take a look at it, you will be surprised I joined both worlds: Emacs and Nvim. 
