# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/blas-config/blas-config-1.0.1.ebuild,v 1.5 2004/11/03 07:55:44 josejx Exp $

DESCRIPTION="Utility to change the default BLAS library"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc ~ppc64 sparc ~alpha"
IUSE=""

DEPEND=""

RDEPEND="app-shells/bash"

src_unpack(){
	cp ${FILESDIR}/${P}.bz2 ${WORKDIR}
	bunzip2 ${WORKDIR}/${P}.bz2
	mv ${WORKDIR}/${P} ${WORKDIR}/${PN}
}

src_install () {
	exeinto /usr/bin
	doexe ${WORKDIR}/blas-config
}
