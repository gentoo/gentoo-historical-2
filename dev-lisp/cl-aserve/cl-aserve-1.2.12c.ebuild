# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-aserve/cl-aserve-1.2.12c.ebuild,v 1.4 2004/06/24 23:41:06 agriffis Exp $

inherit common-lisp

DESCRIPTION="A portable version of AllegroServe which is a web application server for Common Lisp programs."
HOMEPAGE="http://packages.debian.org/unstable/web/cl-aserve.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-portable-aserve/cl-portable-aserve_${PV}+cvs2003.05.11.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-acl-compat
	dev-lisp/cl-htmlgen"

CLPACKAGE=aserve

S=${WORKDIR}/cl-portable-aserve-${PV}+cvs2003.05.11

src_install() {
	common-lisp-install aserve/*.cl aserve/*.asd
	common-lisp-system-symlink

	dodoc ChangeLog README README.cmucl INSTALL.lisp logical-hostnames.lisp
	docinto examples
	dodoc contrib/*.lisp
}
