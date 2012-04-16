# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/weechat/weechat-0.3.7.ebuild,v 1.10 2012/04/16 21:11:28 ranger Exp $

EAPI=3

# Can only add ruby19 support when ruby:1.9 is keyworded.
#USE_RUBY="ruby18 ruby19"
USE_RUBY="ruby18"
RUBY_OPTIONAL="yes"

PYTHON_DEPEND="python? *"

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
	KEYWORDS="amd64 ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

NETWORKS="+irc"
PLUGINS="+alias +charset +fifo +logger +relay +rmodifier +scripts +spell +xfer"
#INTERFACES="+ncurses gtk"
SCRIPT_LANGS="guile lua +perl +python ruby tcl"
IUSE="${SCRIPT_LANGS} ${PLUGINS} ${INTERFACES} ${NETWORKS} +crypt doc nls +ssl"

RDEPEND="
	net-misc/curl[ssl]
	sys-libs/ncurses
	charset? ( virtual/libiconv )
	guile? ( dev-scheme/guile )
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

LANGS=( cs de es fr hu it ja pl pt_BR ru )
for X in "${LANGS[@]}" ; do
	IUSE="${IUSE} linguas_${X}"
done

pkg_setup() {
	use python && python_pkg_setup
	use ruby && ruby-ng_pkg_setup
}

src_prepare() {
	local i

	# fix libdir placement
	sed -i \
		-e "s:lib/:$(get_libdir)/:g" \
		-e "s:lib\":$(get_libdir)\":g" \
		"${S}/CMakeLists.txt" || die "sed failed"

	# install only required translations
	for i in "${LANGS[@]}" ; do
		if ! use linguas_${i} ; then
			sed -i \
				-e "/${i}.po/d" \
				"${S}/po/CMakeLists.txt" || die
		fi
	done
}

# alias, rmodifier, xfer
src_configure() {
	# $(cmake-utils_use_enable gtk)
	# $(cmake-utils_use_enable ncurses)
	local mycmakeargs=(
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
		$(cmake-utils_use_enable guile)
		$(cmake-utils_use_enable doc)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	if use scripts && use python; then
		elog "You may use the following script from upstream to manage your scripts."
		elog "It helps with downloading and updating other scripts:"
		elog "    http://www.weechat.org/scripts/source/stable/weeget.py/"
	fi
}
