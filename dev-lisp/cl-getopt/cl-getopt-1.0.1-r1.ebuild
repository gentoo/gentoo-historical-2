# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-getopt/cl-getopt-1.0.1-r1.ebuild,v 1.2 2004/06/24 23:43:36 agriffis Exp $

inherit common-lisp

DESCRIPTION="A Common Lisp command-line processor similar to GNU getopt_long."
HOMEPAGE="http://www.b9.com"
SRC_URI="ftp://ftp.b9.com/getopt/getopt-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
DEPEND="dev-lisp/common-lisp-controller
	dev-lisp/cl-ptester
	virtual/commonlisp"

CLPACKAGE=getopt

S=${WORKDIR}/getopt-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc LICENSE README
}
