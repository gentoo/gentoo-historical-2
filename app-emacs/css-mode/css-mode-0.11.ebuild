# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/css-mode/css-mode-0.11.ebuild,v 1.3 2004/06/24 22:08:34 agriffis Exp $

inherit elisp

IUSE=""

DESCRIPTION="A major mode for editing Cascading Style Sheets (CSS)"
HOMEPAGE="http://www.garshol.priv.no/download/software/css-mode/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	unpack "${A}"

	# Fix documentation
	sed -i -e 's,HREF="/visuals/standard.css",HREF="standard.css",' \
		"${S}/doco.html"
}

src_install() {
	elisp_src_install
	dohtml -A css "${S}/doco.html" "${S}/standard.css"
}
