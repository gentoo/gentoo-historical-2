# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-cells/cl-cells-20050511.ebuild,v 1.1 2005/05/11 10:58:26 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="Cells is a Common Lisp library providing a data flow extension to CLOS."
HOMEPAGE="http://common-lisp.net/project/cells/
	http://www.tilton-technology.com/cells_top.html"
SRC_URI="mirrors://gentoo/cells-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""

DEPEND="dev-lisp/cl-utils-kt"

CLPACKAGE="cells cells-test"

S=${WORKDIR}/cells

# Note: To update this version, use
# http://common-lisp.net/cgi-bin/viewcvs.cgi/cell-cultures/cells/?cvsroot=cells
# and compare dates.  Then use the "Download tarball" link.

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-gentoo.patch || die
}

src_install() {
	dodir $CLSYSTEMROOT
	insinto $CLSOURCEROOT/cells; doins *.{asd,lisp}
	insinto $CLSOURCEROOT/cells-test; doins cells-test/*.{asd,lisp}
	dosym $CLSOURCEROOT/cells/cells.asd $CLSYSTEMROOT
	dosym $CLSOURCEROOT/cells-test/cells-test.asd $CLSYSTEMROOT
	dodoc doc/*
}

