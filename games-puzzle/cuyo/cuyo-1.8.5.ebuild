# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/cuyo/cuyo-1.8.5.ebuild,v 1.5 2005/07/07 04:37:21 caleb Exp $

inherit kde-functions games

DESCRIPTION="highly addictive and remotely related to tetris"
HOMEPAGE="http://www.karimmi.de/cuyo/"
SRC_URI="http://savannah.nongnu.org/download/cuyo/${P//_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE=""

DEPEND="virtual/libc
	virtual/x11
	=x11-libs/qt-3*
	sys-libs/zlib"

S="${WORKDIR}/${P/_}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^gamesdir.*=/ s:\$(prefix)/games:$(bindir):' \
		-e 's:-O2:@CXXFLAGS@ -Wno-long-long:' src/Makefile.in \
		|| die "sed src/Makefile.in failed"
}

src_compile() {
	set-qtdir 3
	export PATH="${QTDIR}/bin:${PATH}" # bug #70861
	egamesconf \
		--with-qt \
		--with-x \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO ChangeLog
	prepgamesdirs
}
