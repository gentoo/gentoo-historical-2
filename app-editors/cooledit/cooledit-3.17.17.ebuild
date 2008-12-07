# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/cooledit/cooledit-3.17.17.ebuild,v 1.7 2008/12/07 13:04:19 ssuominen Exp $

inherit autotools eutils

DESCRIPTION="Cooledit is a full featured multiple window text editor"
HOMEPAGE="http://freshmeat.net/projects/cooledit/"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/editors/X/cooledit/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
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
		"${FILESDIR}"/${P}-implicit_declarations.patch
	eautoreconf
}

src_compile() {
	# Fix for bug 40152 (04 Feb 2004 agriffis)
	addwrite /dev/ptym/clone:/dev/ptmx
	econf $(use_enable nls)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
