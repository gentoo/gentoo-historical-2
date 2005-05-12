# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-yahoo/cl-yahoo-0.5.ebuild,v 1.1 2005/05/12 03:26:17 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="CL-YAHOO is a Common Lisp interface to the Yahoo! API"
HOMEPAGE="http://www.cliki.net/cl-yahoo"
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""
DEPEND="dev-lisp/cl-s-xml
	dev-lisp/cl-trivial-http"

CLPACKAGE=cl-yahoo

src_install() {
	common-lisp-install cl-yahoo.asd *.lisp
	common-lisp-system-symlink
	dodoc README CHANGES COPYING
}
