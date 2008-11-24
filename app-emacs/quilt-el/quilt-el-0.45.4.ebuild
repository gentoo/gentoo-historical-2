# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/quilt-el/quilt-el-0.45.4.ebuild,v 1.3 2008/11/24 20:47:18 ranger Exp $

inherit elisp eutils

DESCRIPTION="Quilt mode for Emacs"
HOMEPAGE="http://stakeuchi.sakura.ne.jp/dev/quilt-el/"
SRC_URI="http://stakeuchi.sakura.ne.jp/dev/quilt-el/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-util/quilt"

S="${WORKDIR}/${PN}"
SITEFILE=50${PN}-gentoo.el
DOCS="README changelog"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-tramp-recursion.patch"
	epatch "${FILESDIR}/${P}-header-window.patch"
}
