# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-ptester/cl-ptester-2.1.2.ebuild,v 1.5 2005/03/18 07:26:57 mkennedy Exp $

inherit common-lisp

DESCRIPTION="A Common Lisp test harness based on the Franz, Inc. tester module."
HOMEPAGE="http://www.b9.com"
SRC_URI="ftp://ftp.b9.com/ptester/ptester-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=ptester

S=${WORKDIR}/ptester-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dohtml tester.html
}
