# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bpmdj/bpmdj-2.7.ebuild,v 1.5 2006/10/02 07:07:21 flameeyes Exp $

IUSE="mp3 vorbis"

inherit eutils toolchain-funcs

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.source.tgz"

LICENSE="GPL-2"
SLOT="0"
#-amd64: 2.6-2.7 - kbpm-play: common.cpp:42: void common_init(): Assertion `sizeof(signed4)==4' failed. - eradicator
KEYWORDS="-amd64 ~x86 ~ppc"

DEPEND="=x11-libs/qt-3*"

RDEPEND="${DEPEND}
	 mp3? ( dev-perl/MP3-Tag )
	 vorbis? ( media-sound/vorbis-tools )
	 media-sound/alsamixergui
	 virtual/mpg123
	 >=sci-libs/fftw-3"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-qt335.patch"
}

src_compile() {
	addwrite "${QTDIR}/etc/settings"

	cp defines.gentoo defines
	make ${MAKEOPTS} CPP=$(tc-getCXX) CC=$(tc-getCC) VARTEXFONTS=${T}/fonts LDFLAGS="${LDFLAGS} `pkg-config --libs fftw3` `pkg-config --libs alsa` -lrt" || die "make failed"
}

src_install () {
#	make is broken (installs into /bpmdj)
#	make DESTDIR="${D}" install || die
#	mv ${D}/usr/share/doc/{${PN},${PF}}

	exeinto /usr/bin
	doexe alsamixerguis bpmdj-raw bpmdj-record bpmdj-replay copydirstruct fetchdirstruct fetchfiles kbpm-batch kbpm-dj kbpm-merge kbpm-mix kbpm-play rbpm-play record_mixer xmms-play || die "doexe failed"
	use mp3 && doexe bpmdj-import-mp3.pl
	use vorbis && doexe bpmdj-import-ogg.pl
	dodoc authors changelog copyright readme todo || die "dodoc failed"
	mkdir -p ${D}/usr/share/bpmdj
	cp -pPR sequences ${D}/usr/share/bpmdj/ || die "cp failed"
}
