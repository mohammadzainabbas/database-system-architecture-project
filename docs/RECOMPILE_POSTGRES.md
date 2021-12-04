### Recompile Source Code

Typing commands `make`, `sudo make install` and restarting a postgres server via `pg_ctl` again and again can be tiring and slow down your productivity.

So, @herozero777 has written a script just for this purpose.

Simply, run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mohammadzainabbas/database-system-architecture-project/main/scripts/recompile_postgres.sh)"
```

This command will run all of the above mentioned commands for you. Enjoy !!
