# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/bonnie/bonnie-2.0.6.ebuild,v 1.1 2003/02/11 18:57:16 sethbc Exp $

DESCRIPTION="Performance Test of Filesystem I/O using standard C library calls."
HOMEPAGE="http://www.textuality.com/bonnie/"
SRC_URI="http://www.textuality.com/bonnie/bonnie.tar.gz"

LICENSE="bonnie"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
 	unpack ${A} || die
	patch -p0 < ${FILESDIR}/bonnie_man.patch || die
	patch -p0 < ${FILESDIR}/Makefile.patch || die
}

src_compile() {
	make SYSFLAGS="${CFLAGS}" || die
	mv Bonnie bonnie
}

src_install() {
	doman bonnie.1
	dodoc Instructions
	dobin bonnie
}
