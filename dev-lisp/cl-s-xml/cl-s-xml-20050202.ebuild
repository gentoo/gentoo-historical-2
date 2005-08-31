# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-s-xml/cl-s-xml-20050202.ebuild,v 1.5 2005/08/31 17:48:15 swegener Exp $

inherit common-lisp

DESCRIPTION="S-XML is a simple XML parser implemented in Common Lisp."
HOMEPAGE="http://www.common-lisp.net/project/s-xml/"
SRC_URI="mirror://gentoo/s-xml-20040709.tar.gz"
LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="virtual/commonlisp
	dev-lisp/common-lisp-controller"

S=${WORKDIR}/${PN#cl-}

CLPACKAGE=s-xml

src_compile() {
	:
}

src_install() {
	dodir /usr/share/common-lisp/source/s-xml
	dodir /usr/share/common-lisp/systems
	cp -R src ${D}/usr/share/common-lisp/source/s-xml/
	common-lisp-install s-xml.asd
	common-lisp-system-symlink
	dosym /usr/share/common-lisp/source/s-xml/s-xml.asd \
		/usr/share/common-lisp/systems/
}
