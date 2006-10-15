# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/noarp/noarp-1.2.3-r1.ebuild,v 1.3 2006/10/15 13:56:49 xmerlin Exp $

inherit linux-mod linux-info

DESCRIPTION="a kernel module and userspace tool for hiding network interfaces"
HOMEPAGE="http://www.masarlabs.com/noarp/"
SRC_URI="http://www.masarlabs.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/linux-sources"
RDEPEND=""

pkg_setup() {
	linux-mod_pkg_setup
	if kernel_is 2 6; then
		die "${P} supports only 2.4 kernels"
	fi
}

src_compile() {
	set_arch_to_kernel

	econf --prefix=/ || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc README ChangeLog AUTHORS
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo ""
	einfo "Please remember to re-emerge ${PN} when you upgrade your kernel!"
	einfo ""
}
