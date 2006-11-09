# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/sparse/sparse-0.1.ebuild,v 1.1 2006/11/09 04:03:24 vapier Exp $

DESCRIPTION="C semantic parser"
HOMEPAGE="http://kernel.org/pub/linux/kernel/people/josh/sparse/"
SRC_URI="http://kernel.org/pub/linux/kernel/people/josh/sparse/dist/${P}.tar.gz"

LICENSE="OSL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake CFLAGS="${CFLAGS} -fpic" LDFLAGS="${LDFLAGS}" || die
}

src_install() {
	dodir /usr/bin
	emake install BINDIR="${D}"/usr/bin || die
#	newbin check sparse || die
#	dolib.so libsparse.so || die
	dodoc FAQ README
}
