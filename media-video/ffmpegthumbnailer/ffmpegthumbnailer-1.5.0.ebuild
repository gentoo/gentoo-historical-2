# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpegthumbnailer/ffmpegthumbnailer-1.5.0.ebuild,v 1.6 2009/05/20 13:04:55 ssuominen Exp $

EAPI=2

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="http://code.google.com/p/ffmpegthumbnailer"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libpng
	media-libs/jpeg
	>=media-video/ffmpeg-0.4.9_p20070330[-altivec]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README TODO
}
