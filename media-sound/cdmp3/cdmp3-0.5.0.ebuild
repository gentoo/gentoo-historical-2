# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdmp3/cdmp3-0.5.0.ebuild,v 1.5 2008/03/02 12:15:55 aballier Exp $

DESCRIPTION="Conveniently rip audio CDs to MP3 or OGG files."
HOMEPAGE="http://www.roland-riegel.de/cdmp3/index.html"
SRC_URI="http://www.roland-riegel.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="media-sound/cdparanoia
	app-cdr/cdrtools
	media-sound/lame
	media-sound/vorbis-tools
	dev-perl/CDDB_get
	app-misc/bfr"

src_install() {
	dobin cdmp3 || die "couldn't install cdmp3"
	dosym /usr/bin/cdmp3 /usr/bin/cdogg || die "couldn't symlink cdogg"
	dodoc ChangeLog AUTHORS README || die "dodoc failed"
}
