# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mp3burn/mp3burn-0.1.ebuild,v 1.1.1.1 2005/11/30 09:42:28 chriswhite Exp $

IUSE=""

DESCRIPTION="Burn mp3s without filling up your disk with .wav files"
HOMEPAGE="http://mp3burn.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3burn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"

DEPEND="dev-lang/perl
	virtual/mpg123
	app-cdr/cdrtools
	dev-perl/MP3-Info"

src_install() {
	dobin mp3burn
	doman mp3burn.1
	dodoc Changelog INSTALL README
}
