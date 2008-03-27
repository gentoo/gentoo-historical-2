# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-rsm-cache/cl-rsm-cache-1.1_beta1-r1.ebuild,v 1.7 2008/03/27 16:28:14 armin76 Exp $

inherit common-lisp

DESCRIPTION="R. Scott McIntire's Common Lisp cache library."
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-rsm-cache"
SRC_URI="mirror://gentoo/cl-rsm-cache_${PV/_beta/b}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp dev-lisp/cl-rsm-queue"

CLPACKAGE=rsm-cache

S=${WORKDIR}/${P/_beta/b}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc copying copyright
	dohtml *.html *.jpg
	do-debian-credits
}
