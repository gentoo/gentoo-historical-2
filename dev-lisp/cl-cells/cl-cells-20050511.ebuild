# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-cells/cl-cells-20050511.ebuild,v 1.4 2007/07/15 02:50:08 mr_bones_ Exp $

inherit common-lisp eutils

DESCRIPTION="Cells is a Common Lisp library providing a data flow extension to CLOS."
HOMEPAGE="http://common-lisp.net/project/cells/
	http://www.tilton-technology.com/cells_top.html"
SRC_URI="mirror://gentoo/cells-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="dev-lisp/cl-utils-kt
	dev-lisp/cl-plus"

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
