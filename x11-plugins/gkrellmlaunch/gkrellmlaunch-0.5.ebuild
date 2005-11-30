# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmlaunch/gkrellmlaunch-0.5.ebuild,v 1.1 2002/10/16 22:05:33 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a Program-Launcher Plugin for GKrellM2"
SRC_URI="mirror://sourceforge/gkrellmlaunch/${P}.tar.gz"
HOMEPAGE="http://gkrellmlaunch.sourceforge.net/"

DEPEND="=app-admin/gkrellm-2.0*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/gkrellm2/plugins
	doins gkrellmlaunch.so

	dodoc README  
}
