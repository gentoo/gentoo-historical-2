# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gummi/gummi-0.4.8-r1.ebuild,v 1.1 2010/09/22 17:50:35 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="http://gummi.midnightcoding.org"
SRC_URI="http://dev.midnightcoding.org/redmine/attachments/download/25/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pygtksourceview-2.4.0:2
	dev-python/python-poppler
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:2
	x11-libs/pango"

pkg_postinst() {
	elog "Gummi >=0.4.8 supports spell checking through gtkspell. You are"
	elog "required to have dev-python/gtkspell-python installed to use this"
	elog "feature. Support for additional languages can be enabled by"
	elog "installing myspell-** packages for your language of choice."
	distutils_pkg_postinst
}
