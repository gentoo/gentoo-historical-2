# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.1.15.ebuild,v 1.2 2004/04/20 17:12:19 eradicator Exp $

IUSE=""

DESCRIPTION="a better cd encoder"
SRC_URI="http://www.hispalinux.es/~data/files/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://www.hispalinux.es/~data/abcde.php"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

RDEPEND=">=media-sound/id3-0.12
	>=media-sound/cd-discid-0.6
	>=media-sound/cdparanoia-3.9.7
	>=media-sound/vorbis-tools-1.0_rc3
	media-sound/id3v2
	>=media-libs/flac-1*
	>=media-sound/normalize-0.7.4"

DEPEND="${RDEPEND}
	sys-apps/sed"

src_unpack() {
	unpack ${PN}_${PV}.orig.tar.gz

	sed -i 's:/etc/abcde.conf:/etc/abcde/abcde.conf:g' ${S}/abcde
}

src_install() {
	make DESTDIR=${D} etcdir=${D}/etc/abcde install || die
	dodoc COPYING README TODO changelog
}
