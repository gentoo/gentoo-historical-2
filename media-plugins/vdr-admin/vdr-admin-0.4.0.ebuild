# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-admin/vdr-admin-0.4.0.ebuild,v 1.2 2006/06/30 16:16:39 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: Admin OSD - This is not! the webadmin program called vdradmin."
HOMEPAGE="http://htpc-forum.de"
SRC_URI="mirror://vdrfiles/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.37"

S=${WORKDIR}/admin-${PV}

src_unpack() {
	vdr-plugin_src_unpack

	sed -i "s:/etc/vdr/plugins/admin:/usr/share/vdr/admin/bin:" gentoo/admin.conf
	sed -i "s:/etc/conf.d/vdr.admin.cfg:/usr/lib/vdr/rcscript/plugin-admin.sh:" gentoo/{runvdr,*.sh}
}


src_install() {
	vdr-plugin_src_install

	insinto /etc/vdr/plugins/admin
	doins gentoo/admin.conf

	exeinto /usr/share/vdr/admin/bin
	doexe gentoo/{runvdr,*.sh}

	dodoc gentoo/vdr
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	echo
	einfo "There more config Parameter than default are in /etc/conf.d/vdr"
	einfo "Find examples in /usr/share/doc/${P}/vdr.gz"
}
