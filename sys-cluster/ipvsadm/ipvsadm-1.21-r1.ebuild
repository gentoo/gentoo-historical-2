# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ipvsadm/ipvsadm-1.21-r1.ebuild,v 1.1 2003/11/23 17:10:24 iggy Exp $


DESCRIPTION="ipvsadm is a utility to administer the IP virtual server services offered by the Linux kernel with IP virtual server support."
HOMEPAGE="http://linuxvirtualserver.org"
LICENSE="GPL-2"
DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2"

SRC_URI="http://www.linuxvirtualserver.org/software/kernel-2.4/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86"
S="${WORKDIR}/${P}"

src_compile() {
	cd "${S}"
	make || die
}

src_install() {
	into /
	dosbin ipvsadm
	dosbin ipvsadm-save
	dosbin ipvsadm-restore

	doman ipvsadm.8
	doman ipvsadm-save.8
	doman ipvsadm-restore.8

	exeinto /etc/init.d
	newexe ${FILESDIR}/ipvsadm-init ipvsadm
	keepdir /var/lib/ipvsadm

	einfo "You will need a kernel that has ipvs patches to use LVS"
}
