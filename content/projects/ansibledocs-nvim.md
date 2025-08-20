+++
title="ansible-doc.nvim"
description="A Neovim plugin that lets you easily find and render ansible modules directly into the editor. It uses fzf-lua as the core."
weight=899
date=2025-08-20

[taxonomies]
tags=["neovim", "lua", "ansible"]

[extra]
repo_view=true
repo_url="https://github.com/SalOrak/ansible-doc.nvim.git"
local_image="thumbnails/ansible-doc-nvim-logo.png"
+++

# ansible-doc.nvim

I've recently finished another plugin for `Neovim`: `ansible-doc.nvim`. This plugin let's you find ansible module, render the documentation for the module and customize the look and feel directly into your editor.

I think the best way to explain a plugin is, most of the times, to show it, so there you go:



As you can see, with a single keypress mapped to execute `AnsibleDoc` I can access the whole list of ansible modules quite fast I'd say. Then I can fuzzy find my way out of the list to choose exactly the module I want.


## How does it work?

It is rather a simple project as it uses [`fzf-lua`](https://github.com/ibhagwan/fzf-lua) as the core to fuzzy find the modules names.

So, how does it work?
1. First, the plugin calls the `setup()` function, which generates the list of all ansible modules alongside a brief description and stores it in disk.
2. Once the `AnsibleDoc` function is called, it reads from disk the list of all ansible modules if it is no already cached. It uses the list in fzf-lua so you can fuzzy find.
3. Finally, when selecting one module from the list it gets rendered as a new read-only buffer into the editor.


There are a couple of technical decision I had to make. First and foremost, I'm storing the ansible modules in disk, why? Because calling the system command that generates it (which is `ansible-doc --list --json`) is slow, like REALLY slow. How much slow? Well, better an image than words:

![ansible-doc-list-is-slow](/projects/ansible-doc-list-is-slow.png)

I mean, almost **3 seconds** on my computer. I can't wait 3 seconds everytime I want to find a module. I needed to speed that up significantly.

> Rant 1: Okay, yes I have an old computer (7 years old) but that is not an excuse. My ThinkPad T490 is capable of running emacs smoothly but takes 3 seconds to load the list of modules? How am I supposed to **discover** the modules?  This problem is what it made me do the plugin. That and  I don't like using the web for documentation that I already have downloaded in my system. Manuals exist for a reason right? Stop with the ranting... To be fair, I love ansible comes with ansible-doc by default.

That out the way, what is left? Ehem, yes. After selecting the module the idea would be to fetch directly from `ansible-doc` as json. And that is what happens... at least the first time. After that, it is, once again, stored locally as it is faster reading from a file than generating documentation.

Don't believe me? Okay. Next image is how much it takes to generate the `ansible.posix.at` documentation module as JSON:

![ansible-doc-module-time-to-generate](/projects/ansible-doc-module-time-posix-at.png)

A second is not *too much* but hey, I'm looking for a fast solution, the fastest if possible. So, yes, I'm not going to force users to wait at least 1 second each time they render the module. Only the first time they do it which I think is ~reasonable~.

> Rant 2: You could kindly ask, hey but can't you just find the JSON representation of these modules directly in your filesystem? That... that does not exist. You see, the JSON representation is just for output, the documentation is a **python file**. Yep. That is why I'm saving to disk.

And how does that worked out? Well, quite well I'd say. Now it is almost instant to search for any ansible modules as well as rendering them.

Oh! Almost forgot. I added a test function that can be called `require('ansible-doc.test'.all_modules()` that tests all modules from the list. It is quite slow but as a side effect it saves all the modules to disk making it the fastest. Just for your information, all the modules and the list weights a total 154 MB. Quite a chunk I'd say. But that's the tradeoff: speed for disk.

## Conclusion
Aaaand that's it. I hope you enjoy the plugin as much as I do. If you have doubts, issues or suggestions please create an issue in the [GitHub Repository](https://github.com/salorak/ansible-doc.nvim/issues).

**THE END**

> PS: Even though my *problems* related to ansible-doc, I truly enjoy using `ansible`. It is such a complete and simple solution that I cannot but appreciate the art behind it. Thank you to all the developers who contributed to it! <3
