# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kakasi/kakasi-2.3.4.ebuild,v 1.5 2004/06/24 21:48:15 agriffis Exp $

DESCRIPTION="Converts Japanese text between kanji, kana, and romaji."
HOMEPAGE="http://kakasi.namazu.org/"
SRC_URI="http://kakasi.namazu.org/stable/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc alpha"
IUSE=""
DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	doman doc/kakasi.1
	dodoc AUTHORS ChangeLog NEWS ONEWS README README-ja THANKS TODO
	dodoc doc/ChangeLog.lib doc/JISYO doc/README.lib README.wakati
}
