# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wepattack/wepattack-0.1.3.ebuild,v 1.2 2003/01/01 05:13:43 vapier Exp $

MY_P="WepAttack-${PV}"
DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepattack/${MY_P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-libs/zlib
	net-libs/libpcap
	dev-libs/openssl"

S=${WORKDIR}/${MY_P}

src_compile() {
	cd src
	cp Makefile{,.old}
	sed -e "/^CFLAGS=/s:=:=${CFLAGS} :" Makefile.old > Makefile
	emake || die
}

src_install() {
	dobin src/wepattack run/wepattack_{inc,word}
	insinto /etc
	doins conf/wepattack.conf
	dodoc README
}
