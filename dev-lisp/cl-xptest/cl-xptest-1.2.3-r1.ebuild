# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-xptest/cl-xptest-1.2.3-r1.ebuild,v 1.3 2004/07/14 16:19:55 agriffis Exp $

inherit common-lisp

DESCRIPTION="XPTEST is a toolkit for building test suites in Common Lisp"
HOMEPAGE="http://alpha.onshored.com/lisp-software/
	http://www.cliki.net/xptest"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-xptest/cl-xptest_${PV}.orig.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=xptest

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc COPYING README
}
