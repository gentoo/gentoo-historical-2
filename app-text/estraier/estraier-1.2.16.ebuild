# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/estraier/estraier-1.2.16.ebuild,v 1.4 2004/08/10 08:09:46 hattya Exp $

IUSE="debug chasen kakasi zlib"

DESCRIPTION="a personal full-text search system"
HOMEPAGE="http://estraier.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND="dev-db/qdbm
	zlib? ( sys-libs/zlib )
	|| (
		chasen? ( app-text/chasen )
		kakasi? ( app-i18n/kakasi )
	)"

src_compile() {

	local myconf=

	if use chasen; then
		myconf="`use_enable chasen`"

	elif use kakasi; then
		myconf="`use_enable kakasi`"

	fi

	econf \
		`use_enable zlib` \
		`use_enable debug` \
		--enable-dlfilter \
		--enable-regex \
		--with-sysqdbm \
		$myconf \
		|| die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die
	dodoc [A-Z][A-Z]* ChangeLog
	dohtml *.html

	rm ${D}/usr/share/${PN}/{COPYING,ChangeLog}
	rm ${D}/usr/share/${PN}/*.html

}
