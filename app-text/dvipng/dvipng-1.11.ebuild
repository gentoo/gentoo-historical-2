# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipng/dvipng-1.11.ebuild,v 1.16 2009/03/18 19:27:39 armin76 Exp $

EAPI="2"
inherit eutils

DESCRIPTION="A program to translate a DVI (DeVice Independent) files into PNG (Portable Network Graphics) bitmaps"
HOMEPAGE="http://dvipng.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="truetype test"

RDEPEND="media-libs/gd[jpeg,png]
	media-libs/libpng
	virtual/latex-base
	sys-libs/zlib
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	test? ( ||
		( dev-texlive/texlive-fontsrecommended app-text/tetex app-text/ptex )
	)"

src_configure() {
	export VARTEXFONTS="${T}/fonts"
	econf $(use_with truetype freetype) || die "Configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc ChangeLog README RELEASE || die "dodoc failed"
}
