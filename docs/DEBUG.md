## Debug Guide for PostgreSQL👨🏻‍💻

### Table of contents

- [Overview](#overview)
  * [Get started](#get-started)
- [Debugging](#debugging)
  * [Printf](#printf-debug)
  * [GDB](#gdb-debug)
  * [VS Code](#vscode-debug)
---

<a id="overview" />

### 1. Overview

There are several ways to debug PostgreSQL source code. We will mention few of them here. 

<a id="get-started" />

#### 1.1. Get started

In order to debug the PostgreSQL source code, you will first need `PostgreSQL` source code. You can clone it from their official github mirror repository.

```bash
git clone https://github.com/postgres/postgres.git
```

<a id="debugging" />

### 2. Debugging

<a id="printf-debug" />

#### 2.1. Printf

A very basic way to debug any source code is to print out the variables and see what's going on. In `C/C++` you can use [`printf`](https://www.cplusplus.com/reference/cstdio/printf/) function to print with some formatting.

`printf` will write the formatted string to standard output stream `stdout`. In postgres, by default the standard output stream is redirected to the _logfile_.

You can specify the location of _logfile_ when you run `pg_ctl -D <path-to-your-database-cluster> -l <path-to-log-file> start`

For example
```bash
pg_ctl -D /usr/local/pgsql/data -l ~/Desktop/logfile start
```

will redirect the logs to `~/Desktop/logfile` file.

But in some cases, you won't see any output there. Because standard output was disabled by your configuration. 

To enable logging, you need to change your `postgresql.conf` file.

> Note: you will find this file in your PGDATA dir. If you have installed postgres from the source, you can find your configuration file at `/usr/local/pgsql/data/postgresql.conf`

Search and change these options:
```
logging_collector = on
log_destination = 'stderr'
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_file_mode = 0600
```

> Note: read description for the above options first, and decide for yourself if you want to enable that option or not

Now, when you do `printf` it will be redirected to `/usr/local/pgsql/data/log/` directory.

Also, you need to use `fflush` everytime you will use `printf` because usually standard output stream is fully buffered and `fflush` will push everything in the buffer to the stdout print. (if you don't understand what this means, read about _buffer and stdout_)

Alternatively, you can use `elog` or `fprintf` to print. 

Please, refer to the [official doc](https://wiki.postgresql.org/wiki/Developer_FAQ#Run-time) for more information.

<a id="gdb-debug" />

#### 2.2. GDB

GNU Debugger (GDB) is a very powerful tool for debugging. It is a portable debugger that runs on many Unix-like systems and works for many programming languages, including `Ada`, `C`, `C++`, `Objective-C`, `Free Pascal`, `Fortran`, `Go`, and partially others.

To get started, make sure that `gdb` is installed on your machine.

```bash
gdb --version
```

If `gdb` is not installed, please install it first. You can refer to the [installation guide](https://github.com/mohammadzainabbas/database-system-architecture-project/blob/main/docs/INSTALL_GDB.md) for more details.

To work with `gdb` you need to run your PostgreSQL in Debug mode. You can follow [this guide](https://github.com/mohammadzainabbas/database-system-architecture-project/blob/main/docs/DEBUG_MODE.md) for details about _debug mode_ and how to get _postgres backend pid_.

Once you have your _postgres backend pid_, open another terminal and simply run:

```bash
gdb -p <postgres-backend-pid>
```

or

```bash
gdb
attach <postgres-backend-pid>
```

> Note: If you see some errors, it would be because in some OS, due to security reasons you might need to give `gdb` special permissions to attach to another process. This will differ from OS to OS. So, I will leave this to you to search it out for your particular OS.

Please, refer to the [official doc](https://wiki.postgresql.org/wiki/Developer_FAQ#gdb) for more information.

<a id="vscode-debug" />

#### 2.3. VS Code

[`Visual Studio Code`](https://code.visualstudio.com) is the default editor of choice for most of the developers today. To debug in VS Code, you need to follow [this guide](https://github.com/mohammadzainabbas/database-system-architecture-project/blob/main/docs/DEBUG_MODE.md) first to build _PostgreSQL_ in _debug mode_ and get _postgres backend pid_.

Now, open your `postgres` source code in your VS Code and simply run the following commands:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mohammadzainabbas/database-system-architecture-project/main/scripts/setup_debugger.sh)"
```

And now, to use the debugger, press `F5`. And enter the `postgres backend pid` here. And you will be in the debug mode.
