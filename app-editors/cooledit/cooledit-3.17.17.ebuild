# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/cooledit/cooledit-3.17.17.ebuild,v 1.8 2010/04/05 04:04:43 abcd Exp $

inherit autotools eutils

DESCRIPTION="Cooledit is a full featured multiple window text editor"
HOMEPAGE="http://freshmeat.net/projects/cooledit/"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/editors/X/cooledit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="nls"

RDEPEND="x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXau
	app-text/ispell"
DEPEND="${RDEPEND}
	x11-libs/libXpm"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc4.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-implicit_declarations.patch \
		"${FILESDIR}"/${P}-interix.patch \
		"${FILESDIR}"/${P}-interix5.patch

	eautoreconf
}

src_compile() {
	[[ ${CHOST} == *-interix* ]] && export ac_cv_header_wchar_h=no

	# Fix for bug 40152 (04 Feb 2004 agriffis)
	addwrite /dev/ptym/clone:/dev/ptmx
	econf $(use_enable nls)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
