# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xforms/xforms-1.0.ebuild,v 1.7 2004/06/24 22:09:27 agriffis Exp $

S=${WORKDIR}/${P}-release
DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://world.std.com/~xforms/"
SRC_URI="ftp://ncmir.ucsd.edu/pub/xforms/OpenSource/${P}-release.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc amd64"

DEPEND="virtual/x11"
IUSE=""

PROVIDE="virtual/xforms"

src_unpack() {
	unpack $A
	cd ${WORKDIR}/${P}-release

	# use custom CFLAGS
	sed -i -e "s:CDEBUGFLAGS =:CDEBUGFLAGS = ${CFLAGS} #:" \
		-e "s:CDEBUGFLAGS	=:CDEBUGFLAGS	= ${CFLAGS} #:" Imakefile
}

src_compile() {
	xmkmf -a
	sed -i -e s/'demos$'// Makefile

	# use custom CFLAGS
	sed -i -e "s:CDEBUGFLAGS =:CDEBUGFLAGS = ${CFLAGS} #:" \
		-e "s:CDEBUGFLAGS	=:CDEBUGFLAGS	= ${CFLAGS} #:" Makefile

	make || die
}

src_install () {
	make DESTDIR=${D} install || die
}
