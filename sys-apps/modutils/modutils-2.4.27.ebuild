# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/modutils/modutils-2.4.27.ebuild,v 1.10 2005/09/03 21:02:33 corsair Exp $

inherit eutils

DESCRIPTION="Standard kernel module utilities"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/modutils/"
SRC_URI="mirror://kernel/linux/utils/kernel/${PN}/v2.4/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha -amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="virtual/libc
	!virtual/modutils"
PROVIDE="virtual/modutils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-alias.patch
	epatch "${FILESDIR}"/${P}-gcc.patch
	epatch "${FILESDIR}"/${P}-flex.patch
}

src_compile() {
	econf \
		--prefix=/ \
		--disable-strip \
		--enable-insmod-static \
		--disable-zlib \
		|| die "./configure failed"
	emake || die "emake failed"
}

src_install() {
	einstall prefix="${D}" || die "make install failed"
	dodoc CREDITS ChangeLog NEWS README TODO
}
