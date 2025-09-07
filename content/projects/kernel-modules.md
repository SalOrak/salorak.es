+++
title="Linux Kernel Modules"
description="Custom Linux Kernel Modules repository to experiment with."
weight=898
date=2025-08-31

[taxonomies]
tags=["linux", "kernel", "c"]

[extra]
repo_view=true
repo_url="https://github.com/SalOrak/kernel-modules.git"
+++

# Kernel Modules

I have been studying how computers works for a long time. But there was always something itching. I never **truly** understood how Linux works. I mean, I knew about processes, filesystem, drivers, devices, memory management and all of those things. But, how do I generate an image I can boot with QEMU? What does the Linux code looks like? What are the components?

Well, this project attempts to understand **just** a tiny bit about the Linux Kernel: developing custom Linux Kernel Modules.

More important, I'd like to know how *far* you can get developing modules. Why do we have them in the first place? What can I achieve that I can't in userland? If a module crashes, can I crash the whole system? These and more questions are the tip of the iceberg.

So hey! If you feel like following, I'll probably be posting some updates to this page.

For now, what do I have now?


# Time Log

### Baby steps - 31/08/2025

They say the best way to approach a giant project is with baby steps. So here I am. The first thing I did was read. I read about the Linux Kernel, its components, some of their ins on how to contribute to, the lifecycle release and I familiarize with some basic concepts.

> By the way, to familiarize I read the incredible book `Linux Kernel Development` from `Robert Love`. And I checked out the [official website](https://www.docs.kernel.org).

Once I felt confident enough I chose a component to contribute to. It just felt right to choose the modules. Why? Well, because it is easy to develop externally, you can plugged them directly into the current running system and you might as well remove them whenever you like. That is pretty much it. 

Finally, the code, what *I developed* is not actually mine but a fragment of the easiest and simplest Linux Kernel Module from the book directly.

Here is the code
```C
/*
 * hello.c - The Hello, World! Kernel Module
 * From: Linux Kernel Development - Robert Love
*/

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static int hello_init(void)  
{
    printk(KERN_ALERT "I bear a charmed life.\n");
    return 0;
}

static void hello_exit(void)
{
    printk(KERN_ALERT "Out, out, brief candle!\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Shakespeare");
MODULE_DESCRIPTION("A Hello, World module");
```

If it looks simple, it is because its simple. Now for the fun part where I spent most of my time: building the code.

To build a Linux Kernel Module you have to use a live Linux Kernel repository, whether is the one installed on your computer or one from the internet. I decided I wanted to build on the latest version so [I forked the Linux repository](https://github.com/SalOrak/linux.git) and downloaded. Once I had download it, I tried to build it which required me setting up the environment. Luckily for me I use NixOS so a simple `shell.nix` contaning all the necessary dependencies alognside `direnv` did the trick quite fast. Except for the part where I had to fight with `libelf` because NixOS uses a different one that does not contain some functions.

> If you are interested you can look up the `shell.nix` file to see which package I used. But I rather just say it: `elfutils`. Install it instead of `libelf` or you are going to run into some `implicit declaration` problems.

The next step involved actually building the Linux Kernel Module. It is quite straight forward:
1. Create a `Makefile` that contains (for now) a single line: `obj-m := hello.o`. Where `hello` is the name of your *main* file (the one with the initialization). 
    > The kernel uses a different build system called `Kbuild`. Check it out in the official website [Kbuild Documentation](https://docs.kernel.org/kbuild/index.html)
2. Then run the following command: `make -C /path/to/kernel/repo M=$PWD`

Once finished building there should be a ton of files, but the one we are interested in is called `hello.ko`. That is the kernel module that can be imported using `insmod` or removed with `rmmod`.

Now, if it was that easy, why did I spend so much time? Well well well.. I wanted to make the building process of any kernel module I developed easy, so I created a little script `build.sh`. 

The key to the building script is that leverages the NixOS powerful development system as well the common external kernel module development workflow. So now it is rather simple to build any of the Linux Kernel modules I developed whether using NixOS or a loca

You can checkout the repository [here](https://github.com/salorak/kernel-modules/), and if you are interested in the build script you'll find it [here](https://github.com/SalOrak/kernel-modules/blob/master/build.sh).







