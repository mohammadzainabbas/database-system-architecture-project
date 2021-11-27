## Install GDB

This guide will walk you through the installation of _GNU Debugger_ (GDB)

### Table of contents

- [Install GDB on Linux (Ubuntu)](#install-gdb-linux-ubuntu)
- [Install GDB on Mac (Intel based)](#install-gdb-mac-intel)
- [Install GDB on Mac (Apple Silicon `M1 chip`)](#install-gdb-mac-m1-chip)

<a id="install-gdb-linux-ubuntu" />

#### 1. Install GDB on Linux (Ubuntu)

Simply run:

```bash
sudo apt-get install gdb -y
```

<a id="install-gdb-mac-intel" />

#### 2. Install GDB on Mac (Intel based)

Simply run:

```bash
brew install gdb
```

<a id="install-gdb-mac-m1-chip" />

#### 3. Install GDB on Mac (Apple Silicon `M1 chip`)

`GDB` is not currently ported for M1 chips (at the time of the writing). In short, you can't use `brew install gdb` to install it.

1. You first have to install brew with `Rosetta 2`

```bash
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

2. Add an alias to this brew version

If you are using `bash` shell

```bash
echo 'alias ibrew="arch -x86_64 /usr/local/bin/brew"' >> ~/.bashrc && source ~/.bashrc
```

And if you are using `zsh` shell
```zsh
echo 'alias ibrew="arch -x86_64 /usr/local/bin/brew"' >> ~/.zshrc && source ~/.zshrc
```

3. Install `gdb` using brew with rosetta

```bash
ibrew install gdb
```

