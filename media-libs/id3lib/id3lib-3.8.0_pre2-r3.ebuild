# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/id3lib/id3lib-3.8.0_pre2-r3.ebuild,v 1.8 2002/12/09 04:26:11 manson Exp $

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Id3 library for C/C++"
SRC_URI="mirror://sourceforge/id3lib/${MY_P}.tar.gz"
HOMEPAGE="http://id3lib.sourceforge.net/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc "

DEPEND="virtual/glibc"

src_unpack() {

	unpack ${A}

	if [ "`gcc --version | cut -f1 -d.`" -eq 3 ] ||
	   ([ -n "${CXX}" ] && [ "`${CXX} --version | cut -f1 -d.`" -eq 3 ]) ||
	   [ "`gcc --version|grep gcc|cut -f1 -d.|cut -f3 -d\ `" -eq 3 ]
	then
		cd ${S}
		# Patch for compilation with gcc-3.0.x thanks to Dirk Jagdmann (doj),
		# and me (fixed the const char** in utils.cpp)
		#
		# Azarah - 5 May 2002
		patch -p1 <${FILESDIR}/${P}-gcc3.patch || die
	fi
}

src_compile() {

	export CPPFLAGS="${CPPFLAGS} -Wno-deprecated"

	econf || die
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog HISTORY INSTALL README THANKS TODO
#	some example programs to be placed in docs dir.
	make clean
	cp -a examples ${D}/usr/share/doc/${PF}/examples
}
