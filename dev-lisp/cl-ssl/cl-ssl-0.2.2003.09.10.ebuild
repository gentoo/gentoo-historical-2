# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-ssl/cl-ssl-0.2.2003.09.10.ebuild,v 1.4 2004/07/14 16:16:19 agriffis Exp $

inherit common-lisp

DEB_PV=

DESCRIPTION="Common Lisp UFFI interface of the OpenSSL library."
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-ssl.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-ssl/cl-ssl_${PV/.2003/+cvs.2003}.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	dev-libs/openssl
	dev-lisp/cl-uffi
	virtual/commonlisp"

CLPACKAGE=cl-ssl

S=${WORKDIR}/${PN}-${PV/.2003/+cvs.2003}

src_compile() {
	cd cl-ssl
	make linux || die
}

src_install() {
	common-lisp-install cl-ssl/*.asd cl-ssl/*.lisp
	common-lisp-system-symlink
	dodoc COPYING README preamble.html
	exeinto /usr/lib/cl-ssl
	doexe cl-ssl/ssl.so
	do-debian-credits
}


pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
