# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-inflate/cl-inflate-1.1.4.2.1.ebuild,v 1.3 2003/10/16 05:03:57 mkennedy Exp $

inherit common-lisp

DESCRIPTION="Common Lisp package to decompress gzip, jar, and winzip files."
HOMEPAGE="http://opensource.franz.com/deflate/index.html
	http://packages.debian.org/unstable/devel/cl-inflate.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-inflate/${PN}_${PV}.orig.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=inflate

S=${WORKDIR}/${P}

src_install() {
	common-lisp-install inflate.lisp ${FILESDIR}/inflate.asd
	common-lisp-system-symlink
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
