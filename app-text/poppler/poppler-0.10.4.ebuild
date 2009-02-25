# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.10.4.ebuild,v 1.1 2009/02/25 16:41:49 loki_val Exp $

EAPI=2

inherit libtool eutils

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=media-libs/freetype-2.1.8
	>=media-libs/fontconfig-2
	app-text/poppler-data
	>=media-libs/jpeg-6b
	media-libs/openjpeg
	sys-libs/zlib
	dev-libs/libxml2
	!app-text/pdftohtml"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.0 )"

src_configure() {
	econf 	--disable-static		\
		--disable-poppler-qt4		\
		--disable-poppler-glib		\
		--disable-poppler-qt		\
		--disable-gtk-test		\
		--disable-cairo-output		\
		--enable-xpdf-headers		\
		--enable-libjpeg		\
		--enable-libopenjpeg		\
		--enable-zlib			\
		$(use_enable doc gtk-doc)	\
		|| die "configuration failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS ChangeLog NEWS README-XPDF TODO
	rm -f $(find "${D}" -name '*.la')
}
