# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.1.9.ebuild,v 1.2 2006/08/01 20:34:14 swegener Exp $

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.flashtux.org/"
SRC_URI="http://weechat.flashtux.org/download/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="debug perl python ruby ssl lua"

DEPEND="sys-libs/ncurses
	perl? ( dev-lang/perl )
	python? ( virtual/python )
	ruby? ( dev-lang/ruby )
	lua? ( >=dev-lang/lua-5.0 )
	ssl? ( net-libs/gnutls )"

src_compile() {
	# The qt and gtk frontends are not usable, so they're disabled
	econf \
		--enable-ncurses \
		--disable-qt \
		--disable-gtk \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable lua) \
		$(use_enable ssl gnutls) \
		$(use_with debug debug 2) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README TODO || die "dodoc failed"
}
