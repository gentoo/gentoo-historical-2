# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdctl/cdctl-0.15.ebuild,v 1.8 2004/04/13 19:58:18 kugelfang Exp $

inherit eutils
EPATCH_SOURCE=${FILESDIR}

DESCRIPTION="Utility to control your cd/dvd drive"
SRC_URI="mirror://sourceforge/cdctl/${P}.tar.gz"
HOMEPAGE="http://cdctl.sourceforge.net/"

KEYWORDS="x86 ~ppc ~amd64"
SLOT="0"
LICENSE="free-noncomm"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc NEWS NUTSANDBOLTS LICENSE PUBLICKEY README
}
