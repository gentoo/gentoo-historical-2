# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mp3burn/mp3burn-0.1.ebuild,v 1.8 2004/05/10 23:58:59 lv Exp $

IUSE=""

DESCRIPTION="Burn mp3s without filling up your disk with .wav files"
HOMEPAGE="http://mp3burn.sourceforge.net/"
SRC_URI="mirror://sourceforge/mp3burn/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"

DEPEND="dev-lang/perl
	virtual/mpg123
	app-cdr/cdrtools
	dev-perl/MP3-Info"

src_install() {
	dobin mp3burn
	doman mp3burn.1
	dodoc Changelog INSTALL README
}
