# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-3.0.1.ebuild,v 1.2 2008/01/03 12:10:49 aballier Exp $

inherit cmake-utils eutils

DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://www.musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="net-misc/neon
	media-libs/libdiscid"

DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"

S=${WORKDIR}/lib${P}

CMAKE_IN_SOURCE_BUILD=true

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc-4.3-includes.patch"
}

src_install() {
	cmake-utils_src_install
	dodoc README.txt NEWS.txt AUTHORS.txt
}
