# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-pxml/cl-pxml-20030325.ebuild,v 1.2 2003/09/06 22:35:54 msterret Exp $

inherit common-lisp

DESCRIPTION="Common Lisp XML parser"
HOMEPAGE="http://opensource.franz.com/xmlutils/index.html"
SRC_URI="mirror://gentoo/xmlutils-${PV}.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-acl-compat"

CLPACKAGE=pxml

S=${WORKDIR}/xmlutils

src_unpack() {
	unpack ${A}
 	cd ${S}
	# this is a bit beyond me at this point
 	patch -p1 <${FILESDIR}/pxml-gentoo.patch || die
	for i in *.cl ; do mv $i ${i/.cl/.lisp} ; done
}

src_install() {
	common-lisp-install pxml?.lisp ${FILESDIR}/pxml.asd
	# pxml-test.lisp
	common-lisp-system-symlink
	dodoc ChangeLog pxml.txt pxml.htm
}
