# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.5.1.ebuild,v 1.7 2006/07/22 20:07:29 psi29a Exp $

inherit flag-o-matic

DESCRIPTION="Poppler is a PDF rendering library based on the xpdf-3.0 code base."
HOMEPAGE="http://poppler.freedesktop.org"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="jpeg"

RDEPEND=">=media-libs/freetype-2.1.8
	media-libs/fontconfig
	jpeg? ( >=media-libs/jpeg-6b )
	!app-text/pdftohtml"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/automake-1.9.6"

src_compile() {
	# -Os is broken, see bug 124179
	replace-flags -Os -O2

	econf --disable-poppler-qt4 \
		--disable-poppler-glib \
		--disable-poppler-qt \
		--disable-gtk-test \
		--enable-opi \
		--disable-cairo-output \
		--enable-xpdf-headers \
		$(use_enable jpeg libjpeg) \
		|| die "configuration failed"
		# $(use_enable zlib) breaks, see
		# https://bugs.freedesktop.org/show_bug.cgi?id=3948
	emake || die "compilation failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README AUTHORS ChangeLog NEWS README-XPDF TODO pdf2xml.dtd
}

pkg_postinst() {
	ewarn "You need to rebuild everything depending on poppler, use revdep-rebuild"
}
