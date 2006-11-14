# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/listen/listen-1.1.15.ebuild,v 1.2 2006/11/14 21:14:32 sanchan Exp $

inherit toolchain-funcs

CVS_MONTH="Dec"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="Raw listen for TinyOS"

HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/src

src_compile() {
	$(tc-getCC) ${CFLAGS} -o listen raw_listen.c || die "compile failed"
}

src_install() {
	exeinto /usr/bin
	doexe listen  || die "install failed"
}
