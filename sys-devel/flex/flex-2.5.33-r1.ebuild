# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/flex/flex-2.5.33-r1.ebuild,v 1.4 2006/03/06 04:24:54 vapier Exp $

inherit eutils flag-o-matic

#DEB_VER=36
DESCRIPTION="GNU lexical analyser generator"
HOMEPAGE="http://flex.sourceforge.net/"
SRC_URI="mirror://sourceforge/flex/${P}.tar.bz2"
#	mirror://debian/pool/main/f/flex/${PN}_${PV}-${DEB_VER}.diff.gz"

LICENSE="FLEX"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ~ppc-macos ppc64 s390 sh sparc x86"
IUSE="nls static"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	[[ -n ${DEB_VER} ]] && epatch "${WORKDIR}"/${PN}_${PV}-${DEB_VER}.diff
	epatch "${FILESDIR}"/${PN}-2.5.31-include.patch
	epatch "${FILESDIR}"/${P}-isatty.patch #119598
}

src_compile() {
	use static && append-ldflags -static
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS ONEWS README* RoadMap THANKS TODO
	dosym flex /usr/bin/lex
}
