+++
title = "Hello there"
template = "home.html"
+++

# Hello world
Hello world!

```c
int multiply(int x, int y);

int multiply(int x, int y) {
    int result = x * y;
    return result;
}

void main() {
    for (int i = 0; i < 10; i ++){
        printf("Value of %d * %d = %d\n", i, i+1, multiply(i, i+1));
    }
}

```
## This is a subsection

What about some text?
And some **bold** text?
And some *italic* text?
And some ~strikethrough~ text?

I like to `code` in many languages such as `Java` or `C++`.

And I find myself amused by platforms such as [CodeBerg](https://codeberg.org) or [Gitea](https://gitea.com)

### And another subsubsection!

{{ sided_images(left="/images/cv-image_256x256.png", right="/images/detailed-github-nobg_256x256.png",width=256,height=256,op="fill") }}

## Image + Text

{% left_image_text(path="/images/cv-image_256x256.png", size=256) %}
hello world! 
my name is hector and i'm testing a shortcode functionality.

{% end %}

{% right_image_text(path="/images/cv-image_256x256.png", size=256) %}
hello world! 
my name is hector and i'm testing a shortcode functionality.

{% end %}
 
