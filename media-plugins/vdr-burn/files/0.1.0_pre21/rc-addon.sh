# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-burn/files/0.1.0_pre21/rc-addon.sh,v 1.3 2009/03/12 02:18:31 hd_brummy Exp $
#
# rc-addon-script for plugin burn
#
# Joerg Bornkessel hd_brummy@gentoo.org

. /etc/conf.d/vdr.burn

: ${BURN_TMPDIR:=/tmp}
: ${BURN_DATADIR:=/var/vdr/video}
: ${BURN_DVDWRITER:=/dev/dvd}
: ${BURN_ISODIR:=/var/vdr/video/dvd-images}

# be shure BURN_ISODIR is available!
make_isodir() {
if [ ! -e "${BURN_ISODIR}" ]; then
	mkdir "${BURN_ISODIR}"
	touch "${BURN_ISODIR}"/.keep.rc-burn
	chown -R vdr:vdr "${BURN_IOSDIR}"
fi
}

make_isodir

plugin_pre_vdr_start() {

  add_plugin_param "-t ${BURN_TMPDIR}"
  add_plugin_param "-d ${BURN_DATADIR}"
  add_plugin_param "-D ${BURN_DVDWRITER}"
  add_plugin_param "-i ${BURN_ISODIR}"

}
 
