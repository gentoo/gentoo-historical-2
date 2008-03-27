# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-rsm-queue/cl-rsm-queue-1.1.ebuild,v 1.7 2008/03/27 16:31:01 armin76 Exp $

inherit common-lisp

DESCRIPTION="McIntire's Common Lisp Queue Library"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-rsm-queue"
SRC_URI="mirror://gentoo/cl-rsm-queue_1.1.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp "

CLPACKAGE=rsm-queue

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc copying copyright
	dohtml *.html *.jpg
	do-debian-credits
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
