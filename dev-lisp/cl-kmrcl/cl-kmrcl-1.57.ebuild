# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-kmrcl/cl-kmrcl-1.57.ebuild,v 1.2 2003/10/16 05:41:43 mkennedy Exp $

inherit common-lisp

DESCRIPTION="General Utilities for Common Lisp Programs from Kevin Rosenberg"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-kmrcl.html
	http://b9.com/debian.html"
SRC_URI="ftp://ftp.b9.com/kmrcl/kmrcl-${PV}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/cl-rt"

CLPACKAGE=kmrcl

S=${WORKDIR}/kmrcl-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	common-lisp-system-symlink ${CLPACKAGE}-tests
	dodoc README rt-test.lisp
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
