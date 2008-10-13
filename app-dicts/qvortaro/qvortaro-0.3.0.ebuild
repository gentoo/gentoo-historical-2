# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/qvortaro/qvortaro-0.3.0.ebuild,v 1.9 2008/10/13 18:39:55 bangert Exp $

EAPI=1

inherit eutils kde

DESCRIPTION="An Esperanto dictionary (currently only German)"
SRC_URI="mirror://berlios/qvortaro/qVortaro-${PV}.tar.bz2"
HOMEPAGE="http://qvortaro.berlios.de"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/libc
	x11-libs/qt:3"

S=${WORKDIR}/qVortaro-${PV}

src_compile() {
	"${QTDIR}"/bin/qmake QMAKE="${QTDIR}"/bin/qmake || die "qmake failed"
	set-kdedir
	kde_src_compile make || die "make failed!"
}
src_install() {
	make INSTALL_ROOT="${D}" install
}
