# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/magma/magma-1.0_pre3.ebuild,v 1.1 2005/01/27 03:22:15 xmerlin Exp $

inherit eutils linux-mod

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Magma cluster interface"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="http://people.redhat.com/cfeist/cluster/tgz/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-compile.patch || die
}

src_compile() {
	check_KV
	set_arch_to_kernel

	einfo ""
	einfo "Your kernel-sources in /usr/src/linux-${KV} must be properly configured"
	einfo ""

	./configure --kernel_src=${KERNEL_DIR} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc doc/*
}
