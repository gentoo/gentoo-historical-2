# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/toolame/toolame-02l-r1.ebuild,v 1.1 2005/06/19 20:47:23 eradicator Exp $

IUSE=""

inherit eutils

DESCRIPTION="tooLAME - an optimized mpeg 1/2 layer 2 audio encoder"
HOMEPAGE="http://www.planckenergy.com"
SRC_URI="mirror://sourceforge/toolame/${P}.tgz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~sparc ~x86 ~ppc"

DEPEND="virtual/libc
	sys-devel/gcc"

src_compile() {
	epatch ${FILESDIR}/${P}-gentoo.diff || die
	epatch ${FILESDIR}/${P}-uint.patch || die
	emake || die
}

src_install() {
	dobin toolame || die
	dodoc README HISTORY FUTURE html/* text/*
}


