# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmfrog/wmfrog-0.1.6.ebuild,v 1.4 2004/06/24 23:09:43 agriffis Exp $

IUSE=""
DESCRIPTION="This is a weather application, it shows the weather in a graphical way."
SRC_URI="http://www.colar.net/wmapps/wmFrog-${PV}.tgz"
HOMEPAGE="http://www.colar.net/wmapps/"

DEPEND="virtual/x11
	dev-lang/perl
	net-misc/wget"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ppc"

src_compile() {
	cd ${WORKDIR}/wmFrog/Src
	emake || die
}

src_install () {
	dodoc CHANGES COPYING README
	cd ${WORKDIR}/wmFrog/Src
	make DESTDIR=${D} install || die
}
