# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.3.6.ebuild,v 1.2 2011/12/31 18:12:20 binki Exp $

EAPI=3

USE_RUBY="ruby18 ruby19"
RUBY_OPTIONAL="yes"

PYTHON_DEPEND="python? 2"

EGIT_REPO_URI="git://git.sv.gnu.org/weechat.git"
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"
inherit python multilib ruby-ng cmake-utils ${GIT_ECLASS}

DESCRIPTION="Portable and multi-interface IRC client."
HOMEPAGE="http://weechat.org/"
[[ ${PV} == "9999" ]] || SRC_URI="http://${PN}.org/files/src/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-linux ~amd64-linux"
fi

NETWORKS="+irc"
PLUGINS="+alias +charset +fifo +logger +relay +rmodifier +scripts +spell +xfer"
#INTERFACES="+ncurses gtk"
SCRIPT_LANGS="lua +perl +python ruby tcl"
IUSE="${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS} +crypt doc nls +ssl"

RDEPEND="
	sys-libs/ncurses
	charset? ( virtual/libiconv )
	lua? ( dev-lang/lua[deprecated] )
	perl? ( dev-lang/perl )
	ruby? ( $(ruby_implementations_depend) )
	ssl? ( net-libs/gnutls )
	spell? ( app-text/aspell )
	tcl? ( >=dev-lang/tcl-8.4.15 )
"
#	ncurses? ( sys-libs/ncurses )
#	gtk? ( x11-libs/gtk+:2 )
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.15 )
"

DOCS="AUTHORS ChangeLog NEWS README"

#REQUIRED_USE=" || ( ncurses gtk )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	ruby-ng_pkg_setup
}

src_prepare() {
	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		CMakeLists.txt || die "sed failed"
}

# alias, rmodifier, xfer
src_configure() {
	# $(cmake-utils_use_enable gtk)
	# $(cmake-utils_use_enable ncurses)
	mycmakeargs=(
		"-DENABLE_NCURSES=ON"
		"-DENABLE_LARGEFILE=ON"
		"-DENABLE_DEMO=OFF"
		"-DENABLE_GTK=OFF"
		$(cmake-utils_use_enable nls)
		$(cmake-utils_use_enable crypt GCRYPT)
		$(cmake-utils_use_enable spell ASPELL)
		$(cmake-utils_use_enable charset)
		$(cmake-utils_use_enable fifo)
		$(cmake-utils_use_enable irc)
		$(cmake-utils_use_enable logger)
		$(cmake-utils_use_enable relay)
		$(cmake-utils_use_enable scripts)
		$(cmake-utils_use_enable perl)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable ruby)
		$(cmake-utils_use_enable lua)
		$(cmake-utils_use_enable tcl)
		$(cmake-utils_use_enable doc)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if use scripts && use python; then
		elog "You may use the following script from upstream to manage your scripts."
		elog "It helps with downloading and updating other scripts:"
		elog "  http://www.weechat.org/scripts/source/stable/weeget.py/"
	fi
}
