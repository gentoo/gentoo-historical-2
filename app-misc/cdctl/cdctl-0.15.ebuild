# Copyright 2003 Matt Tucker <tuck@whistlingfish.net>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdctl/cdctl-0.15.ebuild,v 1.3 2003/03/28 13:03:24 pvdabeel Exp $

DESCRIPTION="Utility to control your cd/dvd drive"
SRC_URI="mirror://sourceforge/cdctl/${P}.tar.gz"
HOMEPAGE="http://cdctl.sourceforge.net/"
KEYWORDS="x86 ~ppc"
IUSE=""
SLOT="0"
LICENSE="free-noncomm"

DEPEND="virtual/glibc"

inherit eutils
EPATCH_SOURCE="${FILESDIR}"

src_unpack() { 
	unpack "${A}"
	cd "${S}"
	epatch
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS NUTSANDBOLTS LICENSE PUBLICKEY README
}

