# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/submount/submount-0.9-r2.ebuild,v 1.3 2005/02/17 19:12:12 hansmi Exp $

inherit linux-mod

DESCRIPTION="Submount is a new attempt to solve the removable media problem for Linux."
HOMEPAGE="http://submount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-2.4-${PV}.tar.gz
		mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ppc ~sparc ~amd64"
IUSE=""

MODULE_NAMES="subfs(fs:${S}/subfs-${MY_PV})"
BUILD_PARAMS="KDIR=${KV_DIR}"
BUILD_TARGETS="default"

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is 2 4
	then
		MY_PV="2.4-${PV}"
	elif ! use_m
	then
		eerror "This version of submount requires a kernel of 2.6.6 or greater"
		die "Kernel is too old."
	else
		MY_PV="${PV}"
	fi

	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	convert_to_m ${S}/subfs-${MY_PV}/Makefile
}

src_compile() {
	cd ${S}/submountd-${MY_PV}
	econf --sbindir=/sbin || die "econf failed"
	emake || die "emake failed"

	linux-mod_src_compile
}

src_install() {
	cd ${S}/submountd-${MY_PV}
	make install DESTDIR=${D} mandir=/usr/share/man || die "make install failed"

	linux-mod_src_install

	cd ${S}
	./rename-docs ${PV}
	dodoc README* COPYING INSTALL*
}
