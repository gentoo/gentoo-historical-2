# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-dscope/xmms-dscope-1.2.ebuild,v 1.3 2002/10/25 16:52:40 cselkirk Exp $

MY_P=${PN/xmms-/}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Dual Scope visualization plugin for xmms"
SRC_URI="http://hem.passagen.se/joakime/${MY_P}.tar.gz"
HOMEPAGE="http://hem.passagen.se/joakime/linuxapp.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

DEPEND="media-sound/xmms"

src_unpack() {
	unpack ${A}
	cd ${S} || die
	# patch in DESTDIR support
	patch -p0 < ${FILESDIR}/${MY_P}-destdir.patch || die
}

src_compile() {     
	# There is no configure script, but the
	# Makefile does things (mostly) correctly.
 	make clean || die
	emake OPT="$CFLAGS" || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README COPYING Changes
}
