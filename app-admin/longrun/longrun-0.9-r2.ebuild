# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/longrun/longrun-0.9-r2.ebuild,v 1.1 2005/07/31 19:10:25 betelgeuse Exp $

inherit eutils linux-info

DESCRIPTION="A utility to control Transmeta's Crusoe and Efficeon processors"
HOMEPAGE="http://freshmeat.net/projects/longrun/"
DEBIAN_PATCH="${PN}_${PV}-17.diff.gz"
SRC_URI="mirror://kernel/linux/utils/cpu/crusoe/${P}.tar.bz2
		 mirror://debian/pool/main/l/${PN}/${DEBIAN_PATCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-ppc ~x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

CONFIG_CHECK="X86_MSR X86_CPUID"

ERROR_X86_MSR="
Longrun needs a MSR device to function. Please select
MSR under Processor type and features. It can be build
directly into the kernel or as a module.
"

ERROR_X86_CPUID="
Longrun needs a CPUID device to function. Please select
CPUID under Processor type and features. It can be
build directly into the kernel or as a module.
"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	epatch ${DISTDIR}/${DEBIAN_PATCH}
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dosbin longrun || die "dosbin failed"
	doman longrun.1
	dodoc MAKEDEV-cpuid-msr
}

pkg_postinst() {
	if linux_chkconfig_module X86_MSR; then
		einfo "You have compiled MSR as a module."
		einfo "You need to load it before using Longrun."
		einfo "The module is called msr."
		einfo
	fi

	if linux_chkconfig_module X86_CPUID; then
		einfo "You have compiled CPUID as a module."
		einfo "You need to load it before using Longrun."
		einfo "The module is called cpuid."
	fi
}
