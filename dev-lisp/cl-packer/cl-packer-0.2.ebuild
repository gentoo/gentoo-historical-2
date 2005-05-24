# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-packer/cl-packer-0.2.ebuild,v 1.3 2005/05/24 18:48:34 mkennedy Exp $

inherit common-lisp

DESCRIPTION="A Common Lisp library implementing C-style structures, along the lines of Perl's pack() or Python's struct module."
HOMEPAGE="http://www.cliki.net/packer"
SRC_URI="http://www.cs.rice.edu/~froydnj/lisp/packer_${PV}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

S=${WORKDIR}/packer_${PV}

CLPACKAGE=packer

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc README
}
