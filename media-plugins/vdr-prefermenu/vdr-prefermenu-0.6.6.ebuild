# Copyright 2003-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-prefermenu/vdr-prefermenu-0.6.6.ebuild,v 1.3 2007/07/10 23:09:00 mr_bones_ Exp $

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder Prefermenu Plugin"
HOMEPAGE="http://www.olivierjacques.com/vdr/prefermenu/"
SRC_URI="http://famillejacques.free.fr/vdr/prefermenu/vdr-${VDRPLUGIN}-${PV}.tgz
		mirror://vdrfiles/${PN}/vdr-${VDRPLUGIN}-${PV}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.45"

src_install() {
	vdr-plugin_src_install

	touch prefermenu.conf
	insinto /etc/vdr/plugins
	doins prefermenu.conf
	chown vdr:vdr -R ${D}/etc/vdr
}
