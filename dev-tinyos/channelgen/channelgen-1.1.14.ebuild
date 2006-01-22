# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tinyos/channelgen/channelgen-1.1.14.ebuild,v 1.1 2006/01/22 13:01:16 sanchan Exp $

inherit toolchain-funcs

CVS_MONTH="Jul"
CVS_YEAR="2005"
MY_P="tinyos"

DESCRIPTION="Verify channel for CC1000Control, generate preset for given frequency"

HOMEPAGE="http://www.tinyos.net/"
SRC_URI="http://www.tinyos.net/dist-1.1.0/tinyos/source/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs.tar.gz"
LICENSE="Intel"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}-${PV}${CVS_MONTH}${CVS_YEAR}cvs/tools/src/CC1000

src_compile() {
	$(tc-getCC) ${CFLAGS} -o channelgen channelgen.c || die "compile failed"
}

src_install() {
	dodir /usr/bin
	make prefix=${D}/usr install  || die "install failed"
}
