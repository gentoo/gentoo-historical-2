# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-da/ispell-da-1.4.22.ebuild,v 1.2 2003/02/12 13:29:28 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A danish dictionary for ispell"
SRC_URI="http://da.speling.org/filer/${P}.tar.gz"
HOMEPAGE="http://da.speling.org/"

DEPEND="app-text/ispell"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc ~alpha ~mips ~hppa"

src_compile() {
	emake || die
}

src_install () {
	insinto /usr/lib/ispell
	doins dansk.aff dansk.hash
 
	dodoc Documentation/*
}
