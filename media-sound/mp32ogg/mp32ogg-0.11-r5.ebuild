# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp32ogg/mp32ogg-0.11-r5.ebuild,v 1.1 2008/02/28 19:52:41 dev-zero Exp $

inherit eutils

DESCRIPTION="A perl script to convert MP3 files to Ogg Vorbis files."
HOMEPAGE="http://faceprint.com/code/"
SRC_URI="ftp://ftp.faceprint.com/pub/software/scripts/mp32ogg"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64"
IUSE=""

DEPEND=""
RDEPEND="virtual/mpg123
	dev-perl/MP3-Info
	dev-perl/String-ShellQuote
	media-sound/vorbis-tools"

S="${WORKDIR}/"

src_unpack(){
	cp "${DISTDIR}/${A}" "${S}"
	epatch \
		"${FILESDIR}/${P}-r4-mpg321.patch" \
		"${FILESDIR}/${P}-r4-quality.patch" \
		"${FILESDIR}/${PF}-german_umlaut.patch"
}

src_install() {
	dobin mp32ogg
}
