# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-pxmlutils/cl-pxmlutils-0.0.9.ebuild,v 1.2 2004/04/21 17:12:51 vapier Exp $

inherit common-lisp eutils

DESCRIPTION="Portable version of Franz's xmlutils."
HOMEPAGE="http://www.common-lisp.net/project/bese/pxmlutils.html"
SRC_URI="ftp://ftp.common-lisp.net/pub/project/bese/pxmlutils/pxmlutils_${PV}.tar.gz"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller
	dev-lisp/cl-acl-compat
	virtual/commonlisp"

S=${WORKDIR}/pxmlutils_${PV}

CLPACKAGE=pxmlutils

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-allegro-declare-gentoo.patch
}

src_install() {
	common-lisp-install ${FILESDIR}/pxmlutils.asd pxml*.cl
	common-lisp-system-symlink
	dodoc ChangeLog README pxml.{htm,txt}
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
