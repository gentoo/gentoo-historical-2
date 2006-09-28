# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-osdteletext/files/rc-addon.sh,v 1.2 2006/09/28 11:27:38 hd_brummy Exp $
#
# rc-addon-script for plugin osdteletext
#
# Joerg Bornkessel <hd_brummy@gentoo.org>
# Matthias Schwarzott <zzam@gentoo.org>

source /etc/conf.d/vdr.osdteletext

: ${OSDTELETEXT_TMPFS:=yes}
: ${OSDTELETEXT_SIZE:=20}
: ${OSDTELETEXT_DIR:=/var/cache/osdteletext}

plugin_pre_vdr_start() {
	add_plugin_param "-d ${OSDTELETEXT_DIR}"
	add_plugin_param "-n ${OSDTELETEXT_SIZE}"
	
	if [[ ${OSDTELETEXT_TMPFS} == yes ]]; then
		## test on mountet TMPS
		if /bin/mount | /bin/grep -q ${OSDTELETEXT_DIR} ; then
			:
		else
			einfo_level2 mounting videotext dir ${OSDTELETEXT_DIR}
			/bin/mount -t tmpfs -o size=${OSDTELETEXT_SIZE}m,uid=vdr,gid=vdr tmpfs ${OSDTELETEXT_DIR}
		fi
	fi
}

plugin_post_vdr_stop() {
	if [[ ${OSDTELETEXT_TMPFS} == yes ]]; then
		if /bin/mount | /bin/grep -q ${OSDTELETEXT_DIR} ; then
			einfo_level2 unmounting videotext dir ${OSDTELETEXT_DIR}
			/bin/umount ${OSDTELETEXT_DIR}
		fi
	fi
}

# for compatibility
if [[ ${SCRIPT_API:-1} -lt 2 ]]; then
	plugin_pre_vdr_start
fi
