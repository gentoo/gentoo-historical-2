# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ace/ace-1.2-r1.ebuild,v 1.7 2004/06/24 22:15:25 agriffis Exp $

inherit games

DESCRIPTION="DJ Delorie's Ace of Penguins solitaire games"
HOMEPAGE="http://www.delorie.com/store/ace/"
SRC_URI="http://www.delorie.com/store/ace/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/x11
	media-libs/libpng
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.3.4
	>=sys-apps/sed-4"

src_compile() {
	# bug #54701
	export WANT_AUTOMAKE=1.4
	egamesconf || die

	for f in `grep 1.3.4 * -l` ; do
		sed -i -e 's:1.3.4::' ${f} || die "sed ${f} failed"
	done
	emake || die "emake died (first pass)"
	./ltconfig ltmain.sh || die "./ltconfig failed"
	emake || die "emake died (second pass)"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
	dohtml docs/*
	prepgamesdirs
}
