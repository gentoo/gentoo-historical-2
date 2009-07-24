# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlimages/camlimages-3.0.1.ebuild,v 1.1 2009/07/24 20:51:30 aballier Exp $

EAPI=2

inherit eutils

IUSE="doc gif gs gtk jpeg tiff truetype xpm"

DESCRIPTION="An image manipulation library for ocaml"
HOMEPAGE="http://gallium.inria.fr/camlimages/"
SRC_URI="http://gallium.inria.fr/camlimages/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-lang/ocaml-3.10.2[ocamlopt]
	gif? ( media-libs/giflib )
	gtk? ( dev-ml/lablgtk )
	gs? ( virtual/ghostscript )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	media-libs/libpng
	truetype? ( >=media-libs/freetype-2 )
	xpm? ( x11-libs/libXpm )
	"
DEPEND="${DEPEND}
	dev-ml/findlib"

src_prepare() {
	epatch "${FILESDIR}/${P}-lablgtk.patch"
	epatch "${FILESDIR}/${P}-CVE-2009-2295.patch"
}

src_configure() {
	econf \
		$(use_with gif) \
		$(use_with gs) \
		$(use_with gtk lablgtk2) \
		--without-lablgtk \
		$(use_with jpeg) \
		--with-png \
		$(use_with tiff) \
		$(use_with truetype freetype) \
		$(use_with xpm)
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" ocamlsitelibdir="$(ocamlfind printconf destdir)/${PN}" install || die
	dodoc README
	use doc && dohtml doc/*
}
