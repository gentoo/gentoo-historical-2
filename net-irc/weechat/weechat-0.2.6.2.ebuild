# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.2.6.2.ebuild,v 1.2 2009/08/09 20:56:15 flameeyes Exp $

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.flashtux.org/"
SRC_URI="http://weechat.flashtux.org/download/${P}.tar.bz2"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="debug perl python ruby ssl lua spell"

DEPEND="sys-libs/ncurses
	virtual/libiconv
	perl? ( dev-lang/perl )
	python? ( virtual/python )
	ruby? ( dev-lang/ruby )
	lua? ( >=dev-lang/lua-5.0 )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )"
RDEPEND="${DEPEND}"

src_compile() {
	# The qt and gtk frontends are not usable, so they're disabled

	# this is a hack but solves the issue from bug #248030 (wrong
	# dblatex being picked up) — flameeyes
	export ac_cv_prog_DBLATEX_FOUND=no

	econf \
		--enable-ncurses \
		--disable-qt \
		--disable-gtk \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable lua) \
		$(use_enable ssl gnutls) \
		$(use_enable spell aspell) \
		$(use_with debug debug 2) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README TODO || die "dodoc failed"
}
