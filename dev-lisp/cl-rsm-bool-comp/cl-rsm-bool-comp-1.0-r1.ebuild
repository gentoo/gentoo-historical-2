# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-rsm-bool-comp/cl-rsm-bool-comp-1.0-r1.ebuild,v 1.2 2004/04/21 17:13:59 vapier Exp $

inherit common-lisp eutils

DESCRIPTION="R. Scott McIntire's Common Lisp Boolean Function Comparison library."
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-rsm-bool-comp.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-rsm-bool-comp/cl-rsm-bool-comp_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
# Compilation problems on SBCL and runtime SEGV on CMUCL
KEYWORDS="-*"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp "

CLPACKAGE=rsm-bool-comp

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch.gz
}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc copying copyright
	dohtml *.html *.jpg
	do-debian-credits
}
