# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/realpath/realpath-1.9.10.ebuild,v 1.1 2004/05/13 16:14:58 mkennedy Exp $

DESCRIPTION="Return the canonicalized absolute pathname"
HOMEPAGE="http://packages.debian.org/unstable/utils/realpath.html"
SRC_URI="mirror://debian/pool/main/d/dwww/dwww_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~mips ~ppc amd64"

S=${WORKDIR}/dwww-${PV}

src_compile() {
	make LIBS='' VERSION=$PV realpath || die
}

src_install() {
	dobin realpath
	doman man/realpath.1
	dodoc COPYING README TODO BUGS
}
