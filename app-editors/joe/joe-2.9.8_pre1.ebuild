# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/joe/joe-2.9.8_pre1.ebuild,v 1.1 2002/10/19 06:05:37 seemant Exp $

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
SRC_URI="mirror://sourceforge/joe-editor/${MY_P}.tgz"
HOMEPAGE="http://sourceforge.net/projects/joe-editor/"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64"
LICENSE="GPL-1"

DEPEND=">=sys-libs/ncurses-5.2-r2"

#src_unpack() {
#
#	unpack ${A}
#	cd ${S}
#	cp Makefile Makefile.orig
#	sed -e "s/-O2/${CFLAGS}/" Makefile.orig > Makefile
#
#}

src_compile() {                           

	econf || die
	make || die
}

src_install() {                              
#	into /usr
#	dobin joe
#	doman joe.1
#	dolib joerc
#	for i in jmacs jstar jpico rjoe
#	do
#	  dosym joe /usr/bin/$i
#	  dosym joe.1.gz /usr/share/man/man1/$i.1.gz
#	  dolib ${i}rc
#	done
	einstall || die
	dodoc COPYING INFO LIST README TODO VERSION
}
