# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gkrellmlaunch/gkrellmlaunch-0.3.ebuild,v 1.7 2002/07/11 06:30:57 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a Program-Launcher Plugin for GKrellM"
SRC_URI="mirror://sourceforge/gkrellmlaunch/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

HOMEPAGE="http://gkrellmlaunch.sourceforge.net/"
DEPEND=">=app-admin/gkrellm-1.2.1"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins gkrellmlaunch.so

	dodoc README  
}
