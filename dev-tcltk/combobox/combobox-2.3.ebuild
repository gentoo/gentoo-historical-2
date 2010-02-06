# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/combobox/combobox-2.3.ebuild,v 1.1 2010/02/06 23:16:45 jlec Exp $

inherit multilib

DESCRIPTION="A combobox megawidget"
HOMEPAGE="http://www1.clearlight.com/~oakley/tcl/combobox/index.html"
SRC_URI="http://www1.clearlight.com/~oakley/tcl/combobox/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tcl"
DEPEND=""

src_install() {
	insinto /usr/$(get_libdir)/${P}
	doins *tcl *tmml *n || die
	dodoc *txt || die
	dohtml *html || die
}
