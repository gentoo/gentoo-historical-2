# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrelltop/gkrelltop-2.2.4.ebuild,v 1.10 2007/03/12 17:40:26 lack Exp $

inherit gkrellm-plugin

DESCRIPTION="a GKrellM2 plugin which displays the top three processes"
SRC_URI="http://psychology.rutgers.edu/~zaimi/html/${PN}/${PN}.${PV}.tgz"
HOMEPAGE="http://psychology.rutgers.edu/~zaimi/software.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"

IUSE=""

PLUGIN_SO=gkrelltop2.so

src_compile() {
	# Unfortunately, the supplied Makefile won't work properly on
	# non-x86, so we have to do this the hard way.
	CONFIG="-DLINUX -DGKRELLM2 -fPIC `pkg-config gtk+-2.0 --cflags`"
	LIBS="`pkg-config gtk+-2.0 --libs` -shared"
	OBJS="top_three2.o gkrelltop2.o"
	gcc -c $CONFIG $CFLAGS top_three.c -o top_three2.o || die
	gcc -c $CONFIG $CFLAGS gkrelltop.c -o gkrelltop2.o || die
	gcc $LIBS $CONFIG $CFLAGS -o gkrelltop2.so $OBJS || die
}
