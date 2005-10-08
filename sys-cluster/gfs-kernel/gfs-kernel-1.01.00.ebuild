# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gfs-kernel/gfs-kernel-1.01.00.ebuild,v 1.1 2005/10/08 15:28:10 xmerlin Exp $

inherit eutils linux-mod

MY_P="cluster-${PV}"

DESCRIPTION="GFS kernel module"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

DEPEND="|| (
		>=sys-kernel/vanilla-sources-2.6.12
		>=sys-kernel/gentoo-sources-2.6.12
	)
	>=sys-cluster/dlm-headers-1.01.00
	>=sys-cluster/cman-headers-1.01.00"

RDEPEND=""

S="${WORKDIR}/${MY_P}/${PN}"

pkg_setup() {
	if kernel_is 2 4; then
		die "${P} supports only 2.6 kernels"
	fi
}

src_compile() {
	check_KV
	set_arch_to_kernel

	./configure --kernel_src=${KERNEL_DIR} --verbose || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	rm -f ${D}/usr/include/linux/* || die
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo ""
	einfo "Please remember to re-emerge ${PN} when you upgrade your kernel!"
	einfo ""
}
