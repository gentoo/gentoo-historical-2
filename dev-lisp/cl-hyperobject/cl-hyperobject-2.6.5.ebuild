# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-hyperobject/cl-hyperobject-2.6.5.ebuild,v 1.4 2004/06/24 23:44:08 agriffis Exp $

inherit common-lisp

DESCRIPTION="Hyperobject is a Common Lisp library for representing objects.  Hyperobject prints objects in ASCII text, HTML, and XML formats with optional printing of field labels and hyperlinks to related objects."
HOMEPAGE="http://hyperobject.b9.com/
	http://www.cliki.net/hyperobject"
SRC_URI="http://files.b9.com/hyperobject/Archive/hyperobject-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	dev-lisp/cl-kmrcl
	dev-lisp/cl-sql
	virtual/commonlisp"

CLPACKAGE=hyperobject

S=${WORKDIR}/hyperobject-${PV}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
}
