# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wepattack/wepattack-0.1.3-r1.ebuild,v 1.6 2006/11/06 07:12:52 pva Exp $

inherit eutils

MY_P="WepAttack-${PV}"
DESCRIPTION="WLAN tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepattack.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepattack/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-libs/zlib
	net-libs/libpcap
	dev-libs/openssl"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-filter-mac-address.patch
	cd src
	chmod +x wlan
	sed -i \
		-e "/^CFLAGS=/s:=:=${CFLAGS} :" \
		-e 's:-fno-for-scope::g' \
		Makefile
}

src_compile() {
	cd src
	emake || die
}

src_install() {
	dobin src/wepattack run/wepattack_{inc,word} || die
	insinto /etc
	doins conf/wepattack.conf
	dodoc README
}
