# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/geany-plugins/geany-plugins-0.19.ebuild,v 1.1 2010/07/08 07:39:30 polynomial-c Exp $

EAPI="2"

inherit base versionator

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="http://plugins.geany.org/geany-plugins"
SRC_URI="http://plugins.geany.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="enchant gtkspell lua nls"

LINGUAS="be ca da de es fr gl ja pt pt_BR ru tr zh_CN"

RDEPEND="=dev-util/geany-$(get_version_component_range 1-2)*
	enchant? ( app-text/enchant )
	gtkspell? ( app-text/gtkspell )
	lua? ( dev-lang/lua )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		$(use_enable enchant spellcheck) \
		$(use_enable gtkspell) \
		$(use_enable lua geanylua) \
		$(use_enable nls)
}
