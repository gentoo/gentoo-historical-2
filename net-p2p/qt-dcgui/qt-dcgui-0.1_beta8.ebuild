# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qt-dcgui/qt-dcgui-0.1_beta8.ebuild,v 1.1 2002/07/11 09:45:58 seemant Exp $


MY_P=${P/qt-/}
MY_P=${MY_P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Qt based client for DirectConnect"
HOMEPAGE="http://dc.ketelhot.de/"

SRC_URI="http://dc.ketelhot.de/files/dcgui/unstable/source/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86"

DEPEND="=x11-libs/qt-3*
	>=dev-libs/libxml2-2.4.22
	=net-p2p/dclib-${PV}"


src_compile() {

	export CPPFLAGS="${CPPFLAGS} -I/usr/include/libxml2/libxml"

	econf \
		--with-libdc=/usr || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
