# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/rxvt/rxvt-2.7.8-r6.ebuild,v 1.2 2003/03/21 19:53:40 seemant Exp $

inherit eutils

IUSE="motif"

S=${WORKDIR}/${P}
DESCRIPTION="rxvt -- nice small x11 terminal"
HOMEPAGE="http://www.rxvt.org"
SRC_URI="ftp://ftp.rxvt.org/pub/rxvt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc alpha sparc"

DEPEND="virtual/x11
	motif? ( x11-libs/openmotif )"


src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-security.patch
	use motif && epatch ${FILESDIR}/${P}-azz4.diff
}

src_compile() {
	econf \
		--enable-rxvt-scroll \
		--enable-next-scroll \
		--enable-xterm-scroll \
		--enable-transparency \
		--enable-xpm-background \
		--enable-utmp \
		--enable-wtmp \
		--enable-mousewheel \
		--enable-slipwheeling \
		--enable-smart-resize \
		--enable-menubar \
		--enable-languages \
		--enable-xim \
		--enable-shared \
		--enable-keepscrolling || die

	emake || die
}

src_install() {

	einstall || die
	
	cd ${S}/doc
	dodoc README* *.txt BUGS FAQ
	dohtml *.html
}
