# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-png/cl-png-0.4.ebuild,v 1.2 2004/05/10 13:27:02 dholm Exp $

inherit common-lisp

DESCRIPTION="Common Lisp package to read and write PNG image files"
HOMEPAGE="http://www.pvv.ntnu.no/~musum/lisp/code/
	http://www.cliki.net/PNG
	http://packages.debian.org/unstable/devel/cl-png.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-png/cl-png_${PV}.orig.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=png

S=${WORKDIR}/${P}

src_install() {
	common-lisp-install *.cl *.asd
	common-lisp-system-symlink
	dodoc COPYING README
}
