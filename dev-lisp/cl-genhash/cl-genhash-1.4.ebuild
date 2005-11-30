# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-genhash/cl-genhash-1.4.ebuild,v 1.1.1.1 2005/11/30 10:08:29 chriswhite Exp $

inherit common-lisp

DESCRIPTION="Common Lisp library providing support for generic hashtables."
HOMEPAGE="http://www.cliki.net/genhash"
SRC_URI="mirror://gentoo/${P#cl-}.tar.gz"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=genhash

S=${WORKDIR}/${PN#cl-}_${PV}

src_install() {
	common-lisp-install *.{asd,lisp}
	common-lisp-system-symlink
	dodoc README CHANGES
}
