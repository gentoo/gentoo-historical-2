# /lib/rcscripts/addons/raid-start.sh:  Setup raid volumes at boot
# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mdadm/files/raid-start.sh,v 1.7 2008/06/28 16:44:39 vapier Exp $

[ -f /proc/mdstat ] || exit 0

# We could make this dynamic, but eh
#[ -z ${MAJOR} ] && export MAJOR=$(awk '$2 == "md" { print $1 }' /proc/devices)
MAJOR=9

# Try to make sure the devices exist before we use them
create_devs() {
	local node dir
	for node in "$@" ; do
		[ "${node#/dev}" = "${node}" ] && node="/dev/${node}"
		[ -e "${node}" ] && continue

		dir=${node%/*}
		[ ! -d "${dir}" ] && mkdir -p "${dir}"

		mknod "${node}" b ${MAJOR} ${node##*[![:digit:]]}
	done
}

# Start software raid with mdadm (new school)
mdadm_conf="/etc/mdadm/mdadm.conf"
[ -e /etc/mdadm.conf ] && mdadm_conf="/etc/mdadm.conf"
if [ -x /sbin/mdadm -a -f "${mdadm_conf}" ] ; then
	devs=$(awk '/^[[:space:]]*ARRAY/ { print $2 }' "${mdadm_conf}")
	if [ -n "${devs}" ]; then
		ebegin "Starting up RAID devices"
		create_devs ${devs}
		output=$(mdadm -As 2>&1)
		ret=$?
		[ ${ret} -ne 0 ] && echo "${output}"
		eend ${ret}
	fi
fi

partitioned_devs=$(ls /dev/md_d* 2>/dev/null)
if [ -n "${partitioned_devs}" ]; then
	ebegin "Creating RAID device partitions"
	/sbin/blockdev ${partitioned_devs}
	eend 0
	# wait because vgscan runs next, and we want udev to fire
	sleep 1
fi

# vim:ts=4
