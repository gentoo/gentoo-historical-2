# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/par/par-1.52.ebuild,v 1.3 2004/06/28 03:15:35 ciaranm Exp $

MY_P="Par${PV/./}"

DESCRIPTION="par is a paragraph reformatter, vaguely similar to fmt, but better"
HOMEPAGE="http://www.nicemice.net/par/"
SRC_URI="http://www.nicemice.net/par/${MY_P/./}.tar.gz"
LICENSE="freedist"

SLOT="0"
KEYWORDS="~x86 ~sparc ~mips"
IUSE=""
DEPEND="virtual/glibc"
S=${WORKDIR}/${MY_P}

src_compile() {
	make -f protoMakefile CC="cc -c $CFLAGS"
}

src_install() {
	newbin par par-format
	doman par.1
	dodoc releasenotes par.doc
}
