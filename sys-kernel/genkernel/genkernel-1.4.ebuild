# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-1.4.ebuild,v 1.1 2003/07/31 06:05:07 drobbins Exp $

DESCRIPTION="Gentoo autokernel script" 
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2 http://dev.gentoo.org/~drobbins/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${P}


src_install() {
	dodir /etc/kernels
	cp -rf * ${D}/etc/kernels

	exeinto /usr/sbin
	doexe genkernel

	dodoc README
}
