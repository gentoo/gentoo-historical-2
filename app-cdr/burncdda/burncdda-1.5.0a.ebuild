# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/burncdda/burncdda-1.5.0a.ebuild,v 1.3 2007/04/23 18:30:42 armin76 Exp $

DESCRIPTION="Console app for copying burning audio cds"
SLOT="0"
SRC_URI="http://www.thenktor.homepage.t-online.de/burncdda/download/${P}.tar.gz"
LICENSE="GPL-2"
HOMEPAGE="http://www.thenktor.homepage.t-online.de/burncdda/index.html"
IUSE=""
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="dev-util/dialog
	app-cdr/cdrdao
	virtual/cdrtools
	virtual/mpg123
	media-sound/mp3_check
	media-sound/normalize
	media-sound/sox
	media-sound/vorbis-tools"

src_install() {
	dodoc CHANGELOG INSTALL LICENSE
	insinto /etc
	doins burncdda.conf
	dobin burncdda
	insinto /usr/share/man/man1
	doins burncdda.1.gz
}
