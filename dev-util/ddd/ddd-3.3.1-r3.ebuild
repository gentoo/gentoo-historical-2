# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ddd/ddd-3.3.1-r3.ebuild,v 1.2 2002/12/09 04:21:13 manson Exp $

IUSE=""

inherit eutils

S="${WORKDIR}/${P}"
DESCRIPTION="GNU DDD is a graphical front-end for command-line debuggers"
HOMEPAGE="http://www.gnu.org/software/ddd"
SRC_URI="ftp://ftp.easynet.be/gnu/ddd/${P}.tar.gz
	ftp://ftp.easynet.be/gnu/ddd/${P}-html-manual.tar.gz"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1 FDL-1.1"
KEYWORDS="~x86 ~ppc ~sparc "

DEPEND="virtual/x11
	>=sys-devel/gdb-4.16
	>=x11-libs/openmotif-2.1.30"


src_unpack() {
	unpack ${A}
	
	cd ${S}/ddd
	epatch ${FILESDIR}/ddd-3.3.1-gcc3-gentoo.patch
	
	# Fix detection of double hipot(double, double)
	# <azarah@gentoo.org> 05 Dec 2002
	epatch ${FILESDIR}/ddd-3.3.1-detect-hipot.patch
	# Fix not linking to libstdc++
	# <azarah@gentoo.org> 05 Dec 2002
	epatch ${FILESDIR}/ddd-3.3.1-link-libstdc++.patch
}
	
src_compile() {
	CXXFLAGS="${CXXFLAGS} -Wno-deprecated"
	econf || die
	emake || die
}

src_install () {
	dodir /usr/lib
	# If using internal libiberty.a, need to pass
	# $tooldir to 'make install', else we get
	# sandbox errors ... bug #4614.
	# <azarah@gentoo.org> 05 Dec 2002
	einstall tooldir=${D}/usr || die

	# This one is from binutils
	if [ -f ${D}/usr/lib/libiberty.a ]
	then
		rm -f ${D}/usr/lib/libiberty.a
	fi
	# Remove empty dir ...
	rmdir ${D}/usr/lib || :
	
	mv ${S}/doc/README ${S}/doc/README-DOC
	dodoc ANNOUNCE AUTHORS BUGS COPYING* CREDITS INSTALL NEWS* NICKNAMES \
		OPENBUGS PROBLEMS README* TIPS TODO
	
	mv ${S}/doc/* ${D}/usr/share/doc/${PF}
}

