# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ranger/ranger-1.5.2.ebuild,v 1.1 2011/10/26 06:15:06 radhermit Exp $

EAPI="3"
PYTHON_DEPEND="2:2.6 3:3.1"
PYTHON_USE_WITH="ncurses"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45]"

inherit distutils eutils

DESCRIPTION="A vim-inspired file manager for the console"
HOMEPAGE="http://ranger.nongnu.org/"
SRC_URI="http://nongnu.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/less"

pkg_postinst() {
	distutils_pkg_postinst

	elog "Ranger has many optional dependencies to support enhanced file previews."
	elog "See the README or homepage for more details."
}
