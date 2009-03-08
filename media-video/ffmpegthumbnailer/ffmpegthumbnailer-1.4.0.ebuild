# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpegthumbnailer/ffmpegthumbnailer-1.4.0.ebuild,v 1.2 2009/03/08 19:53:14 aballier Exp $

EAPI=2

inherit multilib eutils

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="http://code.google.com/p/ffmpegthumbnailer"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libpng
	media-libs/jpeg
	>=media-video/ffmpeg-0.4.9_p20070330"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-pixelformat.patch"
}

src_configure() {
	econf --disable-dependency-tracking --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
	rm -f "${D}"/usr/$(get_libdir)/libffmpegthumbnailer.la
}
