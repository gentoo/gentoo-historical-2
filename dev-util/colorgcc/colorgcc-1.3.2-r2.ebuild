# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/colorgcc/colorgcc-1.3.2-r2.ebuild,v 1.4 2003/09/06 08:39:20 msterret Exp $

IUSE=""

inherit eutils

S="${WORKDIR}/${P}"
DESCRIPTION="Adds color to gcc output"
HOMEPAGE="http://packages.debian.org/testing/devel/colorgcc.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz
http://ftp.debian.org/debian/pool/main/c/${PN}/${PN}_${PV}-4.1.diff.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="dev-lang/perl"

src_unpack() {
	unpack ${PN}_${PV}.orig.tar.gz

	epatch ${DISTDIR}/${PN}_${PV}-4.1.diff.gz

	# Add support for gcc-config enabled gcc.  You need gcc-config-1.2.7 or
	# later for this ..
	# <azarah@gentoo.org> (25 Dec 2002)
	cd ${S}; epatch ${FILESDIR}/${P}-gcc_config.patch
}

src_compile() {
	echo "Nothing to compile"
}

src_install() {
	exeinto /usr/bin
	doexe colorgcc
	dodir /usr/bin/wrappers
	dosym /usr/bin/colorgcc /usr/bin/wrappers/gcc
	dosym /usr/bin/colorgcc /usr/bin/wrappers/g++
	dosym /usr/bin/colorgcc /usr/bin/wrappers/cc
	dosym /usr/bin/colorgcc /usr/bin/wrappers/c++

	dodoc COPYING CREDITS ChangeLog INSTALL colorgccrc
}

pkg_postinst() {
	if grep /usr/bin/wrappers /etc/profile > /dev/null
	then
		einfo "/etc/profile already updated for wrappers"
	else
		einfo "Add this to the end of your ${ROOT}etc/profile:"
		einfo
		einfo "#Put /usr/bin/wrappers in path before /usr/bin"
		einfo 'export PATH=/usr/bin/wrappers:${PATH}'
	fi
}

