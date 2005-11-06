# Config file for /etc/init.d/gimps

USER="nobody"
GROUP="nobody"

# the number of CPUs GIMPS will use
GIMPS_CPUS="1"

# set up any options you want for GIMPS
# for more info, `mprime -h`
# GIMPS_OPTIONS=""

# this is the directory where GIMPS run-time
# data files will be stored
GIMPS_DIR=/var/lib/gimps
