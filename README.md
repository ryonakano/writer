# Writer

Writer is a word processor designed for elementary OS that lets you create simple and beautiful documents with ease.

## Installation

**Writer is still in the early development and is not available on AppCenter at the present**, but in the future it may be. If you would like to test it now, you can do by building it.

### Other Platforms

Writer may also available on other platforms by some contributors.

Arch Linux users can find Writer under the name [writer-git](https://aur.archlinux.org/packages/writer-git/) in the AUR (thanks to [btd1337](https://github.com/btd1337)):

    aurman -S writer-git

## Building and Installation

You'll need the following dependencies:

* libgtk-3.0-dev (>= 3.22)
* libgtksourceview-3.0-dev
* libgranite-dev (>= 5.2.0)
* libzeitgeist-2.0-dev (use `-Dno_zeitgeist=true` to build without this)
* meson
* valac

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `com.github.ryonakano.writer`

    sudo ninja install
    com.github.ryonakano.writer

## Contributing

There are many ways you can contribute, even if you don't know how to code.

### Reporting Bugs or Suggesting Improvements

Simply [create a new issue](https://github.com/ryonakano/writer/issues/new) describing your problem and how to reproduce or your suggestion. If you are not used to do, [this section](https://elementary.io/docs/code/reference#reporting-bugs) is for you.

### Writing Some Code

We follow the [coding style of elementary OS](https://elementary.io/docs/code/reference#code-style) and [its Human Interface Guidelines](https://elementary.io/docs/human-interface-guidelines#human-interface-guidelines), please try to respect them.

## The Story Behind This App

Actually this repository is a fork of the [original Writer](https://launchpad.net/writer). One day I found the original one and was very impressed, but it didn't seem to be updated at that time and wasn't released to AppCenter. Then I felt I would like to fork it and continue the development.

So this repository would not exist without the work of the developers of the original one Tuur Dutoit, Anthony Huben, Ryan Riffle and [its mockup designer](https://www.deviantart.com/spiceofdesign/art/Writer-Concept-351501580) spiceofdesign. I would like to say thank you very much for them!
