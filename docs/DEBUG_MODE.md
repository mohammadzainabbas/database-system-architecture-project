### Running PostgreSQL in Debug Mode

When you are developing new C code, it is recommended that you work with the build configured with the `--enable-cassert` and `--enable-debug` options.

Enabling asserts `--enable-cassert` turns on many sanity checking options. And enabling debug symbols `--enable-debug` supports use of debuggers (such as gdb) to trace through misbehaving code.

#### 1. Configure with Debug flags

```bash
./configure --enable-cassert --enable-debug CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer"
```

#### 2. Build your code

```bash
make
```

#### 3. Install from source

```bash
sudo make install
```

#### 4. Now start your postgres server

```bash
pg_ctl -D /usr/local/pgsql/data -l logfile start
```
#### 5. Connect to postgres backend

```bash
psql test
```

> Note: replace `test` with the name of your database

#### 6. Get the backend pid

```sql
SELECT pg_backend_pid();
```

This port is the pid of your postgres process.
