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

`printf` will write the formatted string to standard output stream `stdout`. In postgres, by default the standard output stream is redirected to the logfile.

You can specify the location of logfile when you run `pg_ctl -D <path-to-your-database-cluster> -l <path-to-log-file> start`

For example
```bash
pg_ctl -D /usr/local/pgsql/data -l ~/Desktop/logfile start
```

will redirect the logs to `~/Desktop/logfile` file.

But in some cases, you won't see any output there. Because standard output was been disabled by your configuration. 

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

Also, you need to use `fflush` everytime you will use `printf` because usually standard output stream is fully buffered and `fflush` will push everything in the buffer to the stdout print. (if you don't understand what this means, read about buffer and stdout)

Alternatively, you can use `elog` or `fprintf` to print. 

Please, refer to the [official doc](https://wiki.postgresql.org/wiki/Developer_FAQ#Run-time) for more information.


```bash
./configure --enable-cassert --enable-debug CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer"
```