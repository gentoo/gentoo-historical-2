# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-rsm-genetic-alg/cl-rsm-genetic-alg-1.0-r1.ebuild,v 1.5 2007/02/03 17:43:56 flameeyes Exp $

inherit common-lisp

DESCRIPTION="R. Scott McIntire's Common Lisp Genetic Algorithm Library"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-rsm-genetic-alg.html"
SRC_URI="mirror://gentoo/cl-rsm-genetic-alg_${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp dev-lisp/cl-rsm-cache"

CLPACKAGE=rsm-genetic-alg

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc copying copyright
	dohtml *.html *.jpg
	do-debian-credits
}
