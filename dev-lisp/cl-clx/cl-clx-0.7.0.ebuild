# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-clx/cl-clx-0.7.0.ebuild,v 1.1 2005/05/12 17:57:53 mkennedy Exp $

inherit common-lisp eutils

DESCRIPTION="Portable CLX"
HOMEPAGE="http://ftp.linux.org.uk/pub/lisp/sbcl/ http://www.cliki.net/CLX"
SRC_URI="http://ftp.linux.org.uk/pub/lisp/sbcl/clx_${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller"

CLPACKAGE=clx

S=${WORKDIR}/clx_${PV}

src_install() {
	for i in . demo test debug; do
		insinto /usr/share/common-lisp/source/clx/${i}
		doins ${S}/${i}/*.lisp
	done
	insinto /usr/share/common-lisp/source/clx
	doins clx.asd NEWS CHANGES README README-R5
	insinto /usr/share/common-lisp/source/manual
	doins manual/clx.texinfo
	common-lisp-system-symlink
	dodoc CHANGES NEWS README*
}
