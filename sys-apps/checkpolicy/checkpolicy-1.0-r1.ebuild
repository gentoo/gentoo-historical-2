# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/checkpolicy/checkpolicy-1.0-r1.ebuild,v 1.1 2003/08/13 20:49:54 pebenito Exp $

IUSE=""

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

DEPEND="sys-devel/flex
	sys-devel/bison"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/checkpolicy-little_endian.diff
}

src_compile() {
	cd ${S}
	emake EXTRA_CFLAGS="${CFLAGS}"
}

src_install() {
	make DESTDIR="${D}" install
}
