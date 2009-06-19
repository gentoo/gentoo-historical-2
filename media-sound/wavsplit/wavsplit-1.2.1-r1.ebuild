# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wavsplit/wavsplit-1.2.1-r1.ebuild,v 1.3 2009/06/19 13:46:59 ssuominen Exp $

inherit eutils toolchain-funcs

DESCRIPTION="WavSplit is a simple command line tool to split WAV files"
HOMEPAGE="http://sourceforge.net/projects/wavsplit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#-sparc, -amd64: 1.0: "Only supports PCM wave format" error message.
KEYWORDS="~amd64 -sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# remove precomplied binaries
	rm "${S}"/{wavren,wavsplit} || die
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}-large-files.patch
	epatch "${FILESDIR}"/${P}-64bit.patch
}

src_compile(){
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin wavren wavsplit || die "dobin failed"
	doman wavren.1 wavsplit.1 || die "doman failed"
	dodoc BUGS CHANGES CREDITS README README.wavren || die "dodoc failed"
}
