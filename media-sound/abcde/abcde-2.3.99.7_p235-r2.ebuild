# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcde/abcde-2.3.99.7_p235-r2.ebuild,v 1.1 2008/04/14 03:15:23 beandog Exp $

DESCRIPTION="A Better CD Encoder"
HOMEPAGE="http://www.hispalinux.es/~data/abcde.php"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

MY_PV=${P/_p235/}
S="${WORKDIR}/${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac cdparanoia id3 vorbis flac speex lame musepack normalize replaygain"

RDEPEND="
	id3? (
		>=media-sound/id3-0.12
		media-sound/id3v2
	)
	media-sound/cd-discid
	virtual/eject
	aac? ( media-libs/faac )
	cdparanoia? ( media-sound/cdparanoia )
	vorbis? ( media-sound/vorbis-tools )
	flac? ( media-libs/flac )
	speex? ( media-libs/speex )
	lame? ( media-sound/lame )
	musepack? ( media-sound/mppenc )
	normalize? ( >=media-sound/normalize-0.7.4 )
	replaygain? ( vorbis? ( media-sound/vorbisgain )
		lame? ( media-sound/mp3gain ) )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's:/etc/abcde.conf:/etc/abcde/abcde.conf:g' abcde
	sed -i 's:/etc:/etc/abcde/:g' Makefile
}

src_install() {
	dodir /etc/abcde
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README TODO changelog FAQ KNOWN.BUGS USEPIPES
	docinto examples/
	dodoc examples/*
}
