# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/highline/highline-4.2.1.ebuild,v 1.1 2007/10/17 15:49:43 ulm Exp $

inherit elisp

DESCRIPTION="Minor mode to highlight current line in buffer"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki/HighlineMode"
# taken from: http://www.emacswiki.org/cgi-bin/emacs/download/${PN}.el
SRC_URI="mirror://gentoo/${P}.el.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~x86"
IUSE=""

SIMPLE_ELISP=t
SITEFILE=51${PN}-gentoo.el

src_compile() {
	elisp-compile *.el || die "elisp-compile failed"
	elisp-make-autoload-file || die "elisp-make-autoload-file failed"
}
