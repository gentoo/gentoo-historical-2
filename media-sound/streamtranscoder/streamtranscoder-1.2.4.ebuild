# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/streamtranscoder/streamtranscoder-1.2.4.ebuild,v 1.5 2005/08/07 12:52:48 hansmi Exp $

IUSE=""

DESCRIPTION="Command line application to transcode shoutcast/icecast streams to different bitrates"
HOMEPAGE="http://www.oddsock.org"
SRC_URI="http://www.oddsock.org/tools/streamTranscoder/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND=">=media-libs/libogg-1.1
	>=media-libs/libvorbis-1.0.1-r2
	>=media-sound/lame-3.96
	>=media-libs/libmad-0.15.1b
	>=net-misc/curl-7.11.0"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS README
}
