# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/canfep/canfep-1.0.ebuild,v 1.2 2004/06/21 17:18:14 usata Exp $

inherit eutils

IUSE="unicode"

DESCRIPTION="Canna Japanese kana-kanji frontend processor on console"
HOMEPAGE="http://www.geocities.co.jp/SiliconValley-Bay/7584/canfep/"
SRC_URI="http://www.geocities.co.jp/SiliconValley-Bay/7584/canfep/${P}.tar.gz
	unicode? ( http://hp.vector.co.jp/authors/VA020411/patches/canfep_utf8.diff )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -alpha ~sparc ppc"

DEPEND="app-i18n/canna
	sys-libs/ncurses"
RDEPEND="app-i18n/canna"

src_unpack() {

	unpack ${P}.tar.gz
	cd ${S}
	epatch ${DISTDIR}/canfep_utf8.diff
}

src_compile() {

	make CXX="${CXX}" LIBS="-lcanna -lncurses" CFLAGS="${CFLAGS}" \
		|| die "make failed"
}

src_install() {

	dobin canfep

	dodoc 00changes 00readme
}
