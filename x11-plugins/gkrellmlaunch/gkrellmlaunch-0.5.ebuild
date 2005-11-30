# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmlaunch/gkrellmlaunch-0.5.ebuild,v 1.1.1.1 2005/11/30 10:10:38 chriswhite Exp $

inherit multilib

IUSE=""
DESCRIPTION="a Program-Launcher Plugin for GKrellM2"
SRC_URI="mirror://sourceforge/gkrellmlaunch/${P}.tar.gz"
HOMEPAGE="http://gkrellmlaunch.sourceforge.net/"

DEPEND="=app-admin/gkrellm-2*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha amd64"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/$(get_libdir)/gkrellm2/plugins
	doins gkrellmlaunch.so

	dodoc README
}
