# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cowloop/cowloop-3.0.ebuild,v 1.1 2006/12/16 21:43:50 dragonheart Exp $

inherit linux-mod toolchain-funcs

DESCRIPTION="A copy-on-write loop driver (block device) to be used on top of any other block driver"
HOMEPAGE="http://www.atconsultancy.nl/cowloop/"
SRC_URI="http://www.atconsultancy.nl/cowloop/packages/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"
IUSE=""
DEPEND="virtual/libc
	virtual/linux-sources"

S=${WORKDIR}/${P}/src
MODULE_NAMES="cowloop(fs:)"
BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S} -I."
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	einfo "Linux kernel ${KV_FULL}"
	if kernel_is lt 2 6
	then
		eerror "This version only works with 2.6 kernels"
		eerror "For 2.4 kernel support, use version 1.4"
		die "No compatible kernel detected!"
	fi
}

src_compile() {
	linux-mod_src_compile
	touch .gpl_license_accepted
	CC="$(tc-getCC) ${CFLAGS}" emake utils || die "make failed"
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install-utils install-man || die 'make failed'
	dodoc "${S}"/../RELEASENOTES "${S}"/../HOWTO ../doc/*
	dodir /etc/udev/rules.d
	echo 'KERNEL=="cowctl"        NAME="cow/ctl"' > ${D}/etc/udev/rules.d/70-cow.rules
	echo 'KERNEL=="cowloop[0-9]*"  NAME="cow/%n"' >> ${D}/etc/udev/rules.d/70-cow.rules
}
