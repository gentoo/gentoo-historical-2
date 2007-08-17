# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdiscid/libdiscid-0.1.1.ebuild,v 1.1 2007/08/17 10:28:00 coldwind Exp $

DESCRIPTION="Client library to create MusicBrainz enabled tagging applications"
HOMEPAGE="http://musicbrainz.org/products/libdiscid/"
SRC_URI="http://users.musicbrainz.org/~matt/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS="README AUTHORS examples/discid.c"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ${DOCS} || die
}
