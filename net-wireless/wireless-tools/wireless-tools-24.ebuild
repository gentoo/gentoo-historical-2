# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wireless-tools/wireless-tools-24.ebuild,v 1.2 2002/12/09 04:33:20 manson Exp $

S=${WORKDIR}/wireless_tools.24
DESCRIPTION="Wireless Tools"
SRC_URI="http://pcmcia-cs.sourceforge.net/ftp/contrib/wireless_tools.24.tar.gz"
HOMEPAGE="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html"
KEYWORDS="x86 ppc sparc "
SLOT="0"
LICENSE="GPL-2"

src_compile() {
	emake CFLAGS="$CFLAGS" || die
}

src_install () {
	dosbin iwconfig iwgetid iwpriv iwlist iwspy
	dolib libiw.so.23 libiw.a
	doman iwconfig.8 iwlist.8 iwpriv.8 iwspy.8
	dodoc CHANGELOG.h COPYING INSTALL PCMCIA.txt README
}
