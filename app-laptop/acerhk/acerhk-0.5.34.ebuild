# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/acerhk/acerhk-0.5.34.ebuild,v 1.2 2006/11/25 13:21:35 jurek Exp $

inherit linux-mod

DESCRIPTION="Hotkey driver for some Acer and Acer-like laptops"
HOMEPAGE="http://www.informatik.hu-berlin.de/~tauber/acerhk/"
SRC_URI="http://www.informatik.hu-berlin.de/~tauber/${PN}/archives/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 -ppc"
IUSE=""

MODULE_NAMES="acerhk(extra:)"
BUILD_TARGETS="all"

src_unpack()
{
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/kernel-2.6.19-config.h.patch || die "epatch failed"
}

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNELSRC=${KV_DIR} KERNELVERSION=${KV_FULL}"
}

src_install() {
	linux-mod_src_install
	dodoc README COPYING NEWS
	docinto doc
	dodoc doc/*
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo "You can load the module:"
	einfo "% modprobe acerhk poll=1"
	einfo "If you need poll=1 you can set it permanently in /etc/modules.d/acerhk"
	echo
	einfo "If you need more info about this driver you can read the README file"
	einfo "% zmore /usr/share/doc/${PF}/README.gz"
}
