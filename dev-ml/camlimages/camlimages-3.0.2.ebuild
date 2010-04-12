# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ml/camlimages/camlimages-3.0.2.ebuild,v 1.6 2010/04/12 06:55:08 aballier Exp $

EAPI=2

inherit eutils autotools

IUSE="doc gif gs gtk jpeg tiff truetype xpm"

DESCRIPTION="An image manipulation library for ocaml"
HOMEPAGE="http://cristal.inria.fr/camlimages/"
SRC_URI="http://cristal.inria.fr/camlimages/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND=">=dev-lang/ocaml-3.10.2[X,ocamlopt]
	gif? ( media-libs/giflib )
	gtk? ( dev-ml/lablgtk )
	gs? ( app-text/ghostscript-gpl )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	media-libs/libpng
	truetype? ( >=media-libs/freetype-2 )
	xpm? ( x11-libs/libXpm )
	"
DEPEND="${DEPEND}
	dev-ml/ocaml-autoconf
	dev-ml/findlib"

src_prepare() {
	epatch "${FILESDIR}/${P}-tiffread-CVE-2009-3296.patch"
	epatch "${FILESDIR}/${P}-ocaml-autoconf11.patch"
	epatch "${FILESDIR}/${P}-annot.patch"
	epatch "${FILESDIR}/${P}-noxpm.patch"
	eautoreconf
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
