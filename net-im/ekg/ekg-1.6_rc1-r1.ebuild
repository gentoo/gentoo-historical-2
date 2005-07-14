# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ekg/ekg-1.6_rc1-r1.ebuild,v 1.3 2005/07/14 20:07:27 killerfox Exp $

inherit eutils

IUSE="ssl ncurses readline zlib python spell threads"

DESCRIPTION="EKG (Eksperymentalny Klient Gadu-Gadu) - a text client for Polish instant messaging system Gadu-Gadu"
HOMEPAGE="http://dev.null.pl/ekg/"
SRC_URI="http://dev.null.pl/ekg/${P/_/}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 hppa ia64 ~mips ~ppc ~sparc x86"

S="${WORKDIR}/${P/_/}"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6 )
	ncurses? ( sys-libs/ncurses )
	readline? ( sys-libs/readline )
	zlib? ( sys-libs/zlib )
	python? ( dev-lang/python )
	spell? ( >=app-text/aspell-0.50.3 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/ekg-1.6_rc1-fpic.patch
}

src_compile() {
	local myconf="--enable-ioctld --enable-shared --enable-dynamic"
	if use ncurses; then
		myconf="$myconf --enable-force-ncurses"
	else
		myconf="$myconf --disable-ui-ncurses"
	fi
	use readline	&& myconf="$myconf --enable-ui-readline"
	use zlib	|| myconf="$myconf --disable-zlib"
	use ssl		|| myconf="$myconf --disable-openssl"
	use python	&& myconf="$myconf --with-python"
	use spell	&& myconf="$myconf --enable-aspell"
	use threads	&& myconf="$myconf --with-pthread"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die
	dodoc docs/* docs/api/*
}
