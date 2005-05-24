# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-url-rewrite/cl-url-rewrite-0.1.0.ebuild,v 1.3 2005/05/24 18:48:36 mkennedy Exp $

inherit common-lisp

DESCRIPTION="Rewrite (X)HTML attributes with Common Lisp."
HOMEPAGE="http://www.weitz.de/url-rewrite/"
SRC_URI="mirror://gentoo/url-rewrite-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

S=${WORKDIR}/url-rewrite

CLPACKAGE=url-rewrite

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc CHANGELOG README
	dohtml doc/index.html
}
