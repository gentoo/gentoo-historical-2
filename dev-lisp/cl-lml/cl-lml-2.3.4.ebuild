# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-lml/cl-lml-2.3.4.ebuild,v 1.3 2004/05/09 15:01:25 dholm Exp $

inherit common-lisp

DESCRIPTION="Common Lisp package to provide a markup language for generation XHTML web pages"
HOMEPAGE="http://lml.b9.com/
	http://www.cliki.net/LML"
SRC_URI="ftp://lml.med-info.com/lml-${PV}.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=lml

S=${WORKDIR}/lml-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
}
