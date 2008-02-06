# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/hanterm/hanterm-3.1.6-r2.ebuild,v 1.23 2008/02/06 21:56:14 grobian Exp $

IUSE=""

DESCRIPTION="Hanterm -- Korean terminal"
HOMEPAGE="http://www.hanterm.org/"
SRC_URI="http://download.kldp.net/hanterm/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86 ppc"
LICENSE="X11"

DEPEND="virtual/libc
	x11-libs/libXmu
	x11-libs/libICE
	x11-libs/libXaw
	>=x11-libs/Xaw3d-1.5"
RDEPEND="${DEPEND}
	media-fonts/baekmuk-fonts"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:extern char \*malloc();::" \
		-e "s:extern char \*realloc();::" \
		button.c charproc.c
}

src_compile() {

	econf --with-Xaw3d --with-utempter || die
	perl -i -pe "s/VENDORNAME=(.*?) -/VENDORNAME=\"\1\" -/" Makefile || die
	emake || die
}

src_install() {

	einstall || die

	insinto /etc/X11/app-defaults
	newins Hanterm.ad Hanterm.orig
	newins ${FILESDIR}/Hanterm.gentoo Hanterm

	dodir /usr/X11R6/lib/X11
	dosym ../../../../etc/X11/app-defaults /usr/X11R6/lib/X11/app-defaults

	newman hanterm.man hanterm.1

	insinto /usr/share/doc/${PF}
	doins doc/devel/3final.gif
	dohtml doc/devel/hanterm.html

	dodoc README ChangeLog doc/{AUTHORS,THANKS,TODO}
	dodoc doc/devel/hanterm.sgml
	dodoc doc/historic/{ChangeLog*,DGUX.note,README*}
}
