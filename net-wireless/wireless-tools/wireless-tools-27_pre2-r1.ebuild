# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wireless-tools/wireless-tools-27_pre2-r1.ebuild,v 1.2 2004/03/19 03:42:49 latexer Exp $

MY_P=wireless_tools.${PV/_/\.}
S=${WORKDIR}/${MY_P/.pre2/}
DESCRIPTION="A collection of tools to configure wireless lan cards."
SRC_URI="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/${MY_P}.tar.gz"
HOMEPAGE="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html"
KEYWORDS="~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}

	check_KV

	mv Makefile ${T}
	sed -e "s:# KERNEL_SRC:KERNEL_SRC:" \
		${T}/Makefile > Makefile
}

src_compile() {
	emake CFLAGS="$CFLAGS" WARN="" || die
}

src_install () {
	GENTOO_WE_VERSION="`sed -ne '/WIRELESS_EXT/{s:\([^0-9]*\)::;p;q;}' \
		< /usr/src/linux/include/linux/wireless.h`"
	dosbin iwconfig iwevent iwgetid iwpriv iwlist iwspy
	dolib libiw${GENTOO_WE_VERSION}.so.27
	insinto /usr/include/
	doins iwlib.h
	dosym /usr/lib/libiw${GENTOO_WE_VERSION}.so.27 /usr/lib/libiw${GENTOO_WE_VERSION}.so
	dosym /usr/lib/libiw${GENTOO_WE_VERSION}.so.27 /usr/lib/libiw.so
	doman iwconfig.8 iwlist.8 iwpriv.8 iwspy.8
	dodoc CHANGELOG.h COPYING INSTALL PCMCIA.txt README
}
