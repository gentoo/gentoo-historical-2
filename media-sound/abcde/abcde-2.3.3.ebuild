# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.3.3.ebuild,v 1.3 2007/01/13 08:46:13 beandog Exp $

#inherit eutils

DESCRIPTION="a better cd encoder"
HOMEPAGE="http://www.hispalinux.es/~data/abcde.php"
SRC_URI="http://www.hispalinux.es/~data/files/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=media-sound/id3-0.12
	>=media-sound/cd-discid-0.6
	>=media-sound/cdparanoia-3.9.7
	>=media-sound/vorbis-tools-1.0_rc3
	media-sound/id3v2
	>=media-libs/flac-1
	>=media-sound/normalize-0.7.4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:/etc/abcde.conf:/etc/abcde/abcde.conf:g' abcde
	sed -i 's:/etc:/etc/abcde/:g' Makefile
}

src_install() {
	dodir /etc/abcde
	make DESTDIR=${D} install || die "make install failed"
	dodoc README TODO changelog
}
