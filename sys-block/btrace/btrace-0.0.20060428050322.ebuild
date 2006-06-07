# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/btrace/btrace-0.0.20060428050322.ebuild,v 1.2 2006/06/07 20:47:41 robbat2 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="btrace can show detailed info about what is happening on a block device io queue."
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/axboe/blktrace/"
# this is in case Jens ever releases a real version
MY_PV="${PV/0.0.}"
MY_PN="blktrace"
MY_P="${MY_PN}-${MY_PV}"
SRC_URI="mirror://kernel/linux/kernel/people/axboe/${MY_PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="doc"
RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
		|| ( sys-kernel/linux-headers sys-kernel/mips-headers )
		doc? ( app-text/tetex )"
S="${WORKDIR}/${MY_PN}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall -W" || die "emake failed"
	if use doc; then
		emake docs || die "emake docs failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" || die "emake install failed"
	dodoc README
	use doc && doc/blktrace.pdf
}

