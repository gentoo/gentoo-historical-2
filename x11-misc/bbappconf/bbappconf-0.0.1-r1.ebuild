# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbappconf/bbappconf-0.0.1-r1.ebuild,v 1.2 2002/12/09 04:41:50 manson Exp $

S="${WORKDIR}/${P}-peak3"
DESCRIPTION="bbappconf is a utility that allows you to specify window properties in blackbox"
SRC_URI="http://bbtools.windsofstorm.net/sources/devel/${P}-peak3.tar.gz"
HOMEPAGE="http://bbtools.windsofstorm.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="virtual/blackbox"

src_unpack() {

	unpack ${P}-peak3.tar.gz
	cd ${S}
	patch -p1 < ${FILESDIR}/bbappconf.patch
}

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog COPYING NEWS README TODO
}
