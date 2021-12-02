
# Prints the shell username
whoami
# `./configure` you only need to run once when installing for the first time or when changing to debug mode
# For normal/ production configure
# ./configure

# For debug mode configuration
# ./configure --enable-cassert --enable-debug CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer"

make
sudo make install

sudo su - postgres << EOF
echo " ----------------------------------- Code Compilation Complete -------------------------------------"
whoami

# Use paths according to your installation. Note the output will be produced in the same terminal where you
# run this script.
# template:
# <path/to/pg_ctl> -D <path/to/data_dir> <start | stop | restart>  [-l logfile]
/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data restart  # -l logfile restart
exit
EOF

