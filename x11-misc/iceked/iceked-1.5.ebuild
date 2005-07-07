# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/iceked/iceked-1.5.ebuild,v 1.5 2005/07/07 05:20:29 caleb Exp $

DESCRIPTION="IceWM keys editor"
SRC_URI="mirror://sourceforge/icecc/${P}.tar.bz2"
HOMEPAGE="http://icecc.sourceforge.net/"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="x86 ppc"

DEPEND="=x11-libs/qt-3*"

SLOT="0"
src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e "s:/usr/local:/usr:" -i ${PN}.pro || die "sed failed"
	echo >> ${PN}.pro -e "QMAKE_CXXFLAGS_RELEASE += ${CXXFLAGS}\nQMAKE_CFLAGS_RELEASE += ${CFLAGS}"
}

src_compile () {
	addwrite ${QTDIR}/etc/settings
	${QTDIR}/bin/qmake ${PN}.pro
	emake || die
}


src_install () {
	make INSTALL_ROOT="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
}
