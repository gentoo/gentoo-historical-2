# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.9.2.ebuild,v 1.1 2008/09/26 17:52:13 compnerd Exp $

inherit libtool eutils

DESCRIPTION="PDF rendering library based on the xpdf-3.0 code base"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="doc cjk jpeg zlib"

RDEPEND=">=media-libs/freetype-2.1.8
	>=media-libs/fontconfig-2
	cjk? ( app-text/poppler-data )
	jpeg? ( >=media-libs/jpeg-6b )
	zlib? ( sys-libs/zlib )
	dev-libs/libxml2
	!app-text/pdftohtml"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.0 )"

src_compile() {
	econf \
		--disable-poppler-qt4 \
		--disable-poppler-glib \
		--disable-poppler-qt \
		--disable-gtk-test \
		--disable-cairo-output \
		--enable-xpdf-headers \
		$(use_enable doc gtk-doc) \
		$(use_enable jpeg libjpeg) \
		$(use_enable zlib) \
		|| die "configuration failed"
	emake || die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README AUTHORS ChangeLog NEWS README-XPDF TODO
}
