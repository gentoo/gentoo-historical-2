# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-prevalence/cl-prevalence-1.ebuild,v 1.2 2004/04/21 17:12:13 vapier Exp $

inherit common-lisp eutils

DESCRIPTION="Common Lisp Prevalence is a proof of concept implementation of Object Prevalence"
HOMEPAGE="http://homepage.mac.com/svc/prevalence/readme.htm"
SRC_URI="mirror://gentoo/prevalence-${PV}.tar.gz"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lisp/cl-xml"

S=${WORKDIR}/prevalence

CLPACKAGE=prevalence

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/prevalence-${PV}-close-shadow-gentoo.patch
}

src_install() {
	common-lisp-install ${FILESDIR}/prevalence.asd {serialization,prevalence}.lisp
	common-lisp-system-symlink
	dohtml *.html
	insinto /usr/share/common-lisp/source/${CLPACKAGE}/test
	doins test/*.lisp
	insinto /usr/share/common-lisp/source/${CLPACKAGE}/demo
	doins demo*.lisp
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
