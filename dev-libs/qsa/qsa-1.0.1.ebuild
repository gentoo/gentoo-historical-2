# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qsa/qsa-1.0.1.ebuild,v 1.5 2005/04/24 12:50:18 hansmi Exp $

inherit eutils kde-functions

IUSE=""
S="${WORKDIR}/${PN}-x11-free-${PV}"
DESCRIPTION="QSA version ${PV}"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc amd64"
SRC_URI="ftp://ftp.trolltech.com/qsa/source/${PN}-x11-free-${PV}.tar.gz"
HOMEPAGE="http://www.trolltech.com/"
DEPEND=">=x11-libs/qt-3.1.2-r3"

set-qtdir 3.1

src_compile() {
	epatch ${FILESDIR}/${P}-no-examples.diff
	epatch ${FILESDIR}/${P}-sandbox-fix.diff
	./configure -prefix ${D}${QTDIR} -no-ide || die
	emake || die
}

src_install() {

	sed -e "s:${S}:${QTBASE}:g" ${S}/.qmake.cache > ${D}/${QTBASE}/.qmake.cache

	make install
	dodoc INSTALL README LICENSE.GPL
}
