# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/musicbrainz/musicbrainz-1.1.0.ebuild,v 1.1 2003/02/07 22:23:17 rphillips Exp $

DESCRIPTION="Client library to access free metadata about mp3/vorbis/CD media"
S=${WORKDIR}/${P}
SRC_URI="ftp://ftp.musicbrainz.org/pub/musicbrainz/${P}.tar.gz"
HOMEPAGE="http://www.musicbrainz.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc  ~ppc ~alpha"

DEPEND="virtual/glibc"

src_compile() {
	CC="gcc ${CFLAGS}" \
	econf || die

	emake || die "compile problem"
}

src_install() {
	make prefix=${D}/usr install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO docs/mb_howto.txt
}
