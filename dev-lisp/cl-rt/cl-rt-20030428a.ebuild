# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-rt/cl-rt-20030428a.ebuild,v 1.3 2003/10/17 04:35:02 mkennedy Exp $

inherit common-lisp

DEB_PV=1

DESCRIPTION="Common Lisp regression tester from MIT"
HOMEPAGE="http://www-2.cs.cmu.edu/afs/cs/project/ai-repository/ai/lang/lisp/code/testing/rt/
	http://packages.debian.org/unstable/devel/cl-rt.html
	http://www.cliki.net/rt"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-rt/${PN}_${PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/c/cl-rt/cl-rt_${PV}-${DEB_PV}.diff.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=rt

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	epatch cl-rt_${PV}-${DEB_PV}.diff
}

src_install() {
	common-lisp-install rt.lisp ${FILESDIR}/rt.asd
	common-lisp-system-symlink
	dodoc rt-doc.txt rt-test.lisp
	do-debian-credits
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
