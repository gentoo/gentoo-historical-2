# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/dlm-kernel/dlm-kernel-1.00.00.ebuild,v 1.1 2005/06/30 13:27:47 xmerlin Exp $

inherit eutils linux-mod

CLUSTER_VERSION="1.00.00"
DESCRIPTION="GFS Network Block Devices kernel module"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/cluster-${CLUSTER_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

#DEPEND=">=virtual/linux-sources-2.6.12
DEPEND=">=sys-kernel/vanilla-sources-2.6.12_rc1
	>=sys-cluster/cman-kernel-1.00.00"

RDEPEND=""


S="${WORKDIR}/cluster-${CLUSTER_VERSION}/${PN}"

pkg_setup() {
	if kernel_is 2 4; then
		die "${P} supports only 2.6 kernels"
	else
		if ! kernel_is 2 6 9; then
			die "${P} needs a 2.6.9 kernel"
		fi
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
}


pkg_postinst() {
	linux-mod_pkg_postinst

	einfo ""
	einfo "Please remember to re-emerge ${PN} when you upgrade your kernel!"
	einfo ""
}
