# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gsl/gsl-1.2.ebuild,v 1.2 2002/08/14 11:52:27 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The GNU Scientific Library"
SRC_URI="http://mirrors.rcn.net/pub/sourceware/gsl/${P}.tar.gz"
HOMEPAGE="http://sources.redhat.com/gsl/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

src_compile() {
 	
#Avoid locking (can break parallel builds) 	
 	local myconf
 	myconf="--disable-libtool-lock"
	
	econf ${myconf} || die
	emake || die

	#Uncomment the 'make check ...' line if you want to run the test suite.
	#Note that the check.log file will be several megabytes in size.	
	#	make check > check.log 2>&1 || die

}

src_install () {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL KNOWN-PROBLEMS MACHINES NEWS

}
