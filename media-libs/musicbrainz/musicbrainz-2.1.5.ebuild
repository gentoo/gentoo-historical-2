# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-2.1.5.ebuild,v 1.1 2008/01/01 20:06:50 aballier Exp $

inherit libtool

DESCRIPTION="Client library to access metadata of mp3/vorbis/CD media"
HOMEPAGE="http://www.musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/lib${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/lib${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
}

src_compile() {
	econf --enable-cpp-headers || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO docs/mb_howto.txt
}
