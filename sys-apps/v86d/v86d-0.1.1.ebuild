# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/v86d/v86d-0.1.1.ebuild,v 1.1 2007/10/22 21:15:34 spock Exp $

inherit linux-info

DESCRIPTION="A daemon to run x86 code in an emulated environment."
HOMEPAGE="http://dev.gentoo.org/~spock/projects/uvesafb/"
SRC_URI="http://dev.gentoo.org/~spock/projects/uvesafb/archive/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/klibc"
RDEPEND=""

S="${WORKDIR}/${P//_*/}"

pkg_setup() {
	if [ -z "$(grep V86D /usr/lib/klibc/include/linux/connector.h)" ]; then
		eerror "You need to compile klibc against a kernel tree patched with uvesafb"
		eerror "prior to merging this package."
		die "Kernel not patched with uvesafb."
	fi
	linux-info_pkg_setup
}

src_compile() {
	cd ${S}
	./configure --with-klibc
	make KDIR=${KV_DIR} || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README ChangeLog

	insinto /usr/share/${PN}
	doins misc/initramfs
}

pkg_postinst() {
	elog "If you wish to place v86d into an initramfs image, you might want to use"
	elog "'/usr/share/${PN}/initramfs' in your kernel's CONFIG_INITRAMFS_SOURCE."
}
