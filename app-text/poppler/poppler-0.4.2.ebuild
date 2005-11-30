# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/poppler/poppler-0.4.2.ebuild,v 1.1 2005/09/28 15:12:04 dang Exp $

inherit eutils autotools

DESCRIPTION="Poppler is a PDF rendering library based on the xpdf-3.0 code base."
HOMEPAGE="http://poppler.freedesktop.org"
SRC_URI="http://poppler.freedesktop.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~mips"
IUSE="gtk jpeg qt zlib"
# Cairo is in package.mask

RDEPEND=">=media-libs/freetype-2.1.8
	media-libs/fontconfig
	virtual/ghostscript
	gtk? ( >=x11-libs/gtk+-2.4 )
	qt? ( =x11-libs/qt-3* )
	jpeg? ( >=media-libs/jpeg-6b )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/automake-1.9.6"

src_unpack(){
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/poppler-0.4.1-cairo-ft.patch
	eautoreconf
}

src_compile() {
	econf --disable-poppler-qt4 --enable-opi \
		--disable-cairo-output \
		$(use_enable jpeg libjpeg) \
		$(use_enable zlib) \
		$(use_enable gtk poppler-glib) \
		$(use_enable qt poppler-qt) \
		|| die "configuration failed"
	emake || die "compilation failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README AUTHORS ChangeLog NEWS README-XPDF TODO
}
