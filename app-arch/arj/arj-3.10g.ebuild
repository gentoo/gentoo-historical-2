# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/arj/arj-3.10g.ebuild,v 1.4 2004/02/29 12:16:31 plasmaroo Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Utility for opening arj archives."
HOMEPAGE="http://arj.sourceforge.net/"
SRC_URI="mirror://sourceforge/arj/${P}.tar.gz"

KEYWORDS="x86 ~ppc ~sparc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/glibc"

RESTRICT=nostrip

src_compile() {
	cd ${S}
	cd gnu
	autoconf
	econf || die
	cd ../
	make prepare || die "make prepare failed"
	make package || die "make package failed"
}

src_install() {
	cd ${S}/linux-gnu/en/rs/u
	dobin bin/*
	dodoc doc/arj/* ${S}/ChangeLog
}
