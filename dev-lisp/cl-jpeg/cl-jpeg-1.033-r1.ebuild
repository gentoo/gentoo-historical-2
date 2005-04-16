# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-jpeg/cl-jpeg-1.033-r1.ebuild,v 1.7 2005/04/16 22:36:01 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="A JPEG library for Common Lisp"
HOMEPAGE="http://sourceforge.net/projects/cljl"
SRC_URI="mirror://sourceforge/cljl/cljl-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""
DEPEND="dev-lisp/cl-plus"

CLPACKAGE=cl-jpeg

S=${WORKDIR}/cljl

src_unpack() {
	unpack ${A}
	# patch: defconstant - compilation fix for SBCL
	# patch: exports - export symbols at load time as well
	epatch ${FILESDIR}/${PV}-defconstant-gentoo.patch || die
	epatch ${FILESDIR}/${PV}-exports-gentoo.patch || die
}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc LICENSE
}
