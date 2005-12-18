# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/gkrellm-pmu/gkrellm-pmu-2.4.ebuild,v 1.1 2005/12/18 14:42:44 lu_zero Exp $

DESCRIPTION="GKrellM2 plugin for battery display on Apple machines"
HOMEPAGE="http://pbbuttons.sourceforge.net/projects/gkrellm-pmu/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="-* ppc"
IUSE=""

DEPEND=" >=x11-libs/gtk+-2.0
	=app-admin/gkrellm-2*
	app-laptop/pbbuttonsd"

src_install() {
	dodir /usr/lib/gkrellm2/plugins
	emake DESTDIR=${D} PLUGIN_INSTALL="${D}/usr/lib/gkrellm2/plugins" install|| die
	dodoc ChangeLog INSTALL README
}
