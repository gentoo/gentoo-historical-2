# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mp3burn/mp3burn-0.3.3-r1.ebuild,v 1.3 2005/01/01 12:19:11 eradicator Exp $

IUSE=""

inherit eutils

DESCRIPTION="Burn mp3s without filling up your disk with .wav files"
HOMEPAGE="http://sourceforge.net/projects/mp3burn/"
SRC_URI="mirror://sourceforge/mp3burn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64 sparc"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}
	 virtual/mpg123
	 media-libs/flac
	 media-sound/vorbis-tools
	 virtual/cdrtools
	 dev-perl/MP3-Info
	 dev-perl/String-ShellQuote"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-mpg123.patch
}

src_compile() {
	emake
}

src_install() {
	dobin mp3burn
	doman mp3burn.1
	dodoc Changelog INSTALL README
}
