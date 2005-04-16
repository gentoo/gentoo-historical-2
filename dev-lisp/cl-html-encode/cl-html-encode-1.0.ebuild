# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-html-encode/cl-html-encode-1.0.ebuild,v 1.3 2005/04/16 20:16:14 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="Common Lisp library for encoding text in various web-savvy formats."
HOMEPAGE="http://www.cliki.net/html-encode"
SRC_URI="http://www.unmutual.info/software/html-encode-${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""
DEPEND="virtual/commonlisp
	dev-lisp/common-lisp-controller"

CLPACKAGE=html-encode

S=${WORKDIR}/html-encode-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc LICENSE
}
