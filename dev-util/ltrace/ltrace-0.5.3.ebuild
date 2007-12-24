# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.5.3.ebuild,v 1.1 2007/12/24 15:36:17 vapier Exp $

inherit eutils autotools

MY_PV=${PV%.?}
MY_P=${PN}_${MY_PV}
DEB_P=${MY_P}-${PV##*.}

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://ltrace.alioth.debian.org/"
SRC_URI="mirror://debian/pool/main/l/ltrace/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/l/ltrace/${DEB_P}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-libs/elfutils"

S=${WORKDIR}/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}"/${DEB_P}.diff
	cd "${S}"
	epatch "${FILESDIR}"/0.4-parallel-make.patch

	epatch "${FILESDIR}"/${P}-cross.patch
	sed \
		-e 's:uname -m:echo @HOST_CPU@:' \
		sysdeps/linux-gnu/Makefile > sysdeps/linux-gnu/Makefile.in
	eautoconf
}


src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install || die "make install failed"
	prepalldocs
}
