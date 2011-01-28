# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-imonlcd/files/rc-addon.sh,v 1.1 2011/01/28 22:39:35 idl0r Exp $

[ -e "/etc/conf.d/vdr.imonlcd" ] && source /etc/conf.d/vdr.imonlcd

plugin_pre_vdr_start() {
	add_plugin_param "${IMONLCD_DEVICE:+--device ${IMONLCD_DEVICE}}"
	add_plugin_param "${IMONLCD_MODE:+--mode ${IMONLCD_MODE}}"
}
