# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/calcchecksum/calcchecksum-1.6_pre1.ebuild,v 1.3 2004/05/31 20:34:33 vapier Exp $

inherit kde-base
need-kde 3.1

MY_P=${P/_/-}

DESCRIPTION="CalcChecksum is a tool for calculating MD5 and CRC32, TIGER, HAVAL, SHA and some other checksums."
HOMEPAGE="http://calcchecksum.sourceforge.net/"
SRC_URI="mirror://sourceforge/calcchecksum/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_install() {
	einstall || die
	dodoc AUTHORS BUGS ChangeLog INSTALL README TODO VERSION
}
