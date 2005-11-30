# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ezstream/ezstream-0.2.0.ebuild,v 1.1.1.1 2005/11/30 09:38:10 chriswhite Exp $

DESCRIPTION="Enables you to stream mp3 or vorbis files to an icecast server without reencoding"
HOMEPAGE="http://www.icecast.org/ezstream.php"
SRC_URI="http://downloads.xiph.org/releases/ezstream/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libvorbis
	media-libs/libogg
	>=media-libs/libshout-2.1
	media-libs/libtheora
	dev-libs/libxml2"
RDEPEND="net-misc/icecast"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS README
	docinto conf; dodoc conf/ezstream*
}
