# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/modutils/modutils-2.4.22.ebuild,v 1.4 2003/01/09 08:50:25 seemant Exp $

inherit flag-o-matic

S="${WORKDIR}/${P}"
DESCRIPTION="Standard kernel module utilities"
SRC_URI="http://www.kernel.org/pub/linux/utils/kernel/${PN}/v2.4/${P}.tar.bz2"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/modutils/"

KEYWORDS="x86 ppc sparc alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

src_compile() {

	filter-flags -fPIC

	myconf=""
	# see bug #3897 ... we need insmod static, as libz.so is in /usr/lib
	#
	# Final resolution ... dont make it link against zlib, as the static
	# version do not want to autoload modules :(
	myconf="${myconf} --disable-zlib"

	econf \
		--prefix=/ \
		--disable-strip \
		--enable-insmod-static \
		${myconf} || die "./configure failed"
		
	emake || die "emake failed"
}

src_install() {
	einstall prefix="${D}" || die "make install failed"

	dodoc COPYING CREDITS ChangeLog NEWS README TODO
}

pkg_postinst() {
	echo
	einfo "If you get problems after update related to missing"
	einfo "\"keybdev\" module, please recompile your kernel."
	echo
}

