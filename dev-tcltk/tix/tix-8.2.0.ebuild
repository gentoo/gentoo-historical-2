# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tix/tix-8.2.0.ebuild,v 1.14 2004/04/13 00:41:39 mr_bones_ Exp $

inherit eutils

MY_P=${P/-/}
S=${WORKDIR}/${MY_P}/unix
DESCRIPTION="A widget library for Tcl/Tk. Has been ported to Python and Perl, too."
HOMEPAGE="http://sourceforge.net/projects/tixlibrary/"
SRC_URI="mirror://sourceforge/tixlibrary/${MY_P}b1.tar.gz"
IUSE=""
LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="x86 ~ppc"

DEPEND=">=sys-apps/portage-2.0.47-r10
		>=sys-apps/sed-4
		dev-lang/tk"

src_unpack() {
	unpack ${A}
	cd ${S}/..
	epatch "${FILESDIR}/${PF}-gentoo.diff"
}

src_compile() {
	econf \
		--enable-gcc \
		--with-tcl=/usr/lib \
		--with-tk=/usr/lib \
		--enable-stubs \
		--enable-threads \
		--enable-shared || die "./configure failed"

	ebegin "Fixing the Makefile..."
	sed -e 's:TK_LIBS =:TK_LIBS = -L/usr/X11R6/lib -lX11:' \
		-e 's:^\(SHLIBS_LD_LIBS.*\):\1 ${TK_LIBS}:' \
		-i ${S}/unix/Makefile

	eend $?
	emake -j1 || die "emake failed"
}

src_install() {
	dodir /usr/include
	einstall || die
}
