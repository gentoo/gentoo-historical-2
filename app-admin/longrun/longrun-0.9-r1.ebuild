# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/longrun/longrun-0.9-r1.ebuild,v 1.5 2003/09/23 20:20:55 aliz Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A utility to control Transmeta's Crusoe processor"
SRC_URI="mirror://kernel/linux/utils/cpu/crusoe/${P}.tar.bz2"
HOMEPAGE="http://freshmeat.net/projects/longrun/"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc"

DEPEND="virtual/glibc"

# Include fix from debian
src_unpack() {
	unpack ${A} ; cd ${S}
	epatch ${FILESDIR}/${PF}-debian-gcc-3.diff
}

src_compile() {
	emake || die
}

src_install() {
	dosbin longrun

	doman longrun.1

	dodoc COPYING MAKEDEV-cpuid-msr
}
