# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-prevalence/cl-prevalence-1-r1.ebuild,v 1.4 2004/07/11 05:06:50 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="Common Lisp Prevalence is a proof of concept implementation of Object Prevalence"
HOMEPAGE="http://homepage.mac.com/svc/prevalence/readme.html"
SRC_URI="mirror://gentoo/prevalence-${PV}.tar.gz"

LICENSE="LLGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lisp/cl-s-xml"

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
