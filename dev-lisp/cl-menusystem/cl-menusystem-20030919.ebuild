# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-menusystem/cl-menusystem-20030919.ebuild,v 1.6 2005/05/24 18:48:34 mkennedy Exp $

inherit common-lisp

DESCRIPTION="CL-MENUSYSTEM is a menu system for Common Lisp that implements menu control and settings editing for Common Lisp applications."
HOMEPAGE="http://www.cs.indiana.edu/~bmastenb/software/cl-menusystem/"
SRC_URI="http://www.cs.indiana.edu/~bmastenb/software/cl-menusystem/cl-menusystem-${PV:0:4}-${PV:4:2}-${PV:6:2}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=cl-menusystem

S=${WORKDIR}/${PN}

src_install() {
	common-lisp-install *.lisp cl-menusystem.asd
	common-lisp-system-symlink
	dodoc DOCUMENTATION README
}
