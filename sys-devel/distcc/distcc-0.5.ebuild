# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/distcc/distcc-0.5.ebuild,v 1.2 2002/07/05 21:31:07 drobbins Exp $

SRC_URI="http://ftp.samba.org/ftp/distcc/${P}.tar.gz"
HOMEPAGE="http://ftp.samba.org/ftp/distcc/"
DESCRIPTION="a program to distribute compilation of C code across several machines on a network"
DEPEND="virtual/glibc dev-libs/popt"
SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

src_compile() {
	./configure --prefix=/usr --mandir=/usr/share/man || die "config"
	#Disable creation of PDF documentation
	cd man
	mv Makefile Makefile.orig
	sed < Makefile.orig > Makefile -e 's:distcc.pdf::g' -e 's:distccd.pdf::g'
	cd ${S}
	emake || die "emake"
}

src_install () {
	dobin src/distcc src/distccd
	doman man/*.1
	dodoc man/*.html man/*.ps README 
}
