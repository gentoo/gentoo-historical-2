# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.3.0.ebuild,v 1.1 2010/01/18 15:33:39 scarabeus Exp $

EAPI=2
inherit cmake-utils

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.org/"
SRC_URI="http://${PN}.org/files/src/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

NETWORKS="jabber +irc"
PLUGINS="+charset +fifo +logger relay +scripts +spell"
INTERFACES="+ncurses gtk"
SCRIPT_LANGS="lua +perl +python ruby tcl"
IUSE="${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS} doc nls +ssl"

RDEPEND="
	charset? ( virtual/libiconv )
	gtk? ( x11-libs/gtk+:2 )
	jabber? ( dev-libs/iksemel )
	lua? ( dev-lang/lua[deprecated] )
	ncurses? ( sys-libs/ncurses )
	perl? ( dev-lang/perl )
	python? ( virtual/python )
	ruby? ( dev-lang/ruby )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15 )
"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.15 )
"

DOCS="AUTHORS ChangeLog NEWS README UPGRADE_0.3"

src_configure() {
	local x

	for x in ${IUSE}; do
		if [[ "${x/+/}" = gtk ]]; then
			mycmakeargs="${mycmakeargs} $(cmake-utils_use_enable ${x/+/})"
		else
			mycmakeargs="${mycmakeargs} $(cmake-utils_use_disable ${x/+/})"
		fi
	done
	cmake-utils_src_configure
}
