# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-acl-compat/cl-acl-compat-1.2.12c.ebuild,v 1.4 2004/06/24 23:39:50 agriffis Exp $

inherit common-lisp

DESCRIPTION="Compatibility layer for Allegro Common Lisp"
HOMEPAGE="http://packages.debian.org/unstable/web/cl-acl-compat.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-portable-aserve/cl-portable-aserve_${PV}+cvs2003.05.11.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=acl-compat

S=${WORKDIR}/cl-portable-aserve-${PV}+cvs2003.05.11

src_install() {
	dodir /usr/share/common-lisp/source/
	cp -r acl-compat/ ${D}/usr/share/common-lisp/source/
	common-lisp-install acl-compat/acl-compat.asd
	common-lisp-system-symlink
}
