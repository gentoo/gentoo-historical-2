# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-de/ispell-de-20011124.ebuild,v 1.8 2004/05/14 04:44:00 jhuebel Exp $

MY_P=igerman98-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="German and Swiss dictionaries for ispell"
SRC_URI="http://lisa.goe.net/~bjacke/igerman98/dict/${MY_P}.tar.bz2"
HOMEPAGE="http://lisa.goe.net/~bjacke/igerman98/dict"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc x86 sparc alpha mips hppa amd64"

DEPEND="app-text/ispell"

src_compile() {
	make || die
	make \
		german.hash swiss || die
}

src_install () {
	make \
		DESTDIR=${D} \
		install swiss-install || die

	insinto /usr/lib/ispell
	doins german.aff german.hash

	dodoc Documentation/*
}
