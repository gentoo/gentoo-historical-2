# /lib/rcscripts/addons/lvm-user-stop.sh
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lvm-user/files/lvm-user-stop.sh,v 1.1.1.1 2005/11/30 09:44:18 chriswhite Exp $

# Stop LVM

if [ -x /sbin/vgchange ] && [ -f /etc/lvmtab -o -d /etc/lvm ] && \
	[ -d /proc/lvm  -o "`grep device-mapper /proc/misc 2>/dev/null`" ]
then
	ebegin "Shutting down the Logical Volume Manager"
	/sbin/vgchange -a n >/dev/null
	eend $? "Failed to shut LVM down"
fi

# vim:ts=4
