# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-xmls/cl-xmls-1.2.ebuild,v 1.2 2005/04/17 00:39:15 mkennedy Exp $

inherit common-lisp

DESCRIPTION="XMLS is a small, simple, non-validating XML parser for Common Lisp."
HOMEPAGE="http://www.common-lisp.net/project/xmls/
	http://www.cliki.net/xmls"
SRC_URI="http://www.common-lisp.net/project/xmls/xmls-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=xmls

S=${WORKDIR}/xmls-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc Changelog COPYING
	dohtml README.html
	cp -r tests ${D}/usr/share/doc/${P}/
	dodoc run-tests.sh
}
