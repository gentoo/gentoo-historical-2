# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.0.3.ebuild,v 1.3 2002/07/11 06:30:40 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a better cd encoder"
SRC_URI="http://lly.org/~rcw/abcde/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://lly.org/~rcw/abcde/page/"
SLOT="0"
DEPEND=">=media-sound/id3-0.12
        >=media-sound/cd-discid-0.6
        >=media-sound/cdparanoia-3.9.7
		>=media-sound/vorbis-tools-1.0_rc3
		media-sound/id3v2"

src_unpack() {
    unpack ${PN}_${PV}.orig.tar.gz
    cd ${S}
    cp Makefile Makefile.orig
    patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_install () {
    cd ${S}
    dodir /etc/abcde
    make DESTDIR=${D} install || die
    dodoc COPYING README TODO changelog
}

