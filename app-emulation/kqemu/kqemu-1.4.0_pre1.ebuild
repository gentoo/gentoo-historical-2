# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/kqemu/kqemu-1.4.0_pre1.ebuild,v 1.4 2009/05/25 10:00:31 lu_zero Exp $

inherit eutils flag-o-matic linux-mod toolchain-funcs

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Multi-platform & multi-targets cpu emulator and dynamic translator kernel fast execution module"
HOMEPAGE="http://bellard.org/qemu/"
SRC_URI="http://bellard.org/qemu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""

pkg_setup() {
	MODULE_NAMES="kqemu(misc:${S})"
	linux-mod_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's:MODULE_PARM(\([^,]*\),"i");:module_param(\1, int, 0);:' kqemu-linux.c
	sed -e 's:-Werror::' -i common/Makefile #260876
	sed -e '/^CC/d;/^HOST_CC/d;' \
		-e 's/\(^MON_CC=\).*/\1$(CC)/' \
		-e "s/\(^MON_LD=\).*/\1$(tc-getLD)/" \
		-e 's/^\(TOOLS_CFLAGS.*\)/\1 $(CFLAGS)/' \
		-e 's/^\(MON_CFLAGS.*\)/\1 $(CFLAGS)/' \
		-e 's/^\(KERNEL_CFLAGS.*\)/\1 $(CFLAGS)/' \
		-e 's/^CFLAGS=\(.*\)/CFLAGS+=\1/' \
		-i common/Makefile
	epatch "${FILESDIR}/${P}-missing-sched-header.patch"
}

src_compile() {
	filter-flags -fpie -fstack-protector

	./configure --kernel-path="${KV_DIR}" \
				--cc="$(tc-getCC)" \
				--host-cc="$(tc-getBUILD_CC)" \
				--extra-cflags="${CFLAGS}" \
				--extra-ldflags="${LDFLAGS}" \
		|| die "could not configure"

	make || die "Make failed"
}

src_install() {
	linux-mod_src_install

	# udev rule
	dodir /etc/udev/rules.d/
	echo 'KERNEL=="kqemu*", NAME="%k", GROUP="qemu", MODE="0660"' > ${D}/etc/udev/rules.d/48-qemu.rules

	# Module doc
	dodoc "${S}/README"
	dohtml "${S}/kqemu-doc.html"

	# module params
	dodir /etc/modprobe.d
	echo "options kqemu major=0" > ${D}/etc/modprobe.d/kqemu
}

pkg_postinst() {
	linux-mod_pkg_postinst
	enewgroup qemu
	elog "Make sure you have the kernel module loaded before running qemu"
	elog "and your user is in the 'qemu' group"
}
