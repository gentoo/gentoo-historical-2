# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/moto4lin/moto4lin-0.3.ebuild,v 1.6 2006/01/10 14:55:58 r3pek Exp $

inherit toolchain-funcs

DESCRIPTION="Moto4lin is file manager and seem editor for Motorola P2K phones"
HOMEPAGE="http://moto4lin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND="dev-libs/libusb
	=x11-libs/qt-3*"

src_compile() {
	# We need this addwrite since the uic program tries to create
	# locks in there :/
	addwrite "${ROOT}/usr/qt/3/etc/settings"

	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake
	emake \
		CC="$(tc-getCC) ${CFLAGS}" \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		LINK="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	make INSTALL_ROOT=${D} install || die "make install failed"
	dodoc ChangeLog README
}
