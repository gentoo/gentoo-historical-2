# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tree/tree-1.4.ebuild,v 1.2 2003/06/12 18:26:25 agriffis Exp $

DESCRIPTION="Lists directories recursively, and produces an indented listing of files."

NV="${PV}b3"
SRC_URI="ftp://mama.indstate.edu/linux/tree/${PN}-${NV}.tgz"
HOMEPAGE="http://mama.indstate.edu/users/ice/tree/"
LICENSE="Artistic"
KEYWORDS="~x86 ~ppc ~sparc alpha"
DEPEND="virtual/glibc"
SLOT="0"

src_compile() {
	emake || die
}

src_install () {
	insinto /usr/bin
	dobin tree
	doman tree.1
	dodoc CHANGES LICENSE README*
}
