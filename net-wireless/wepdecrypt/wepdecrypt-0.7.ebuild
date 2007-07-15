# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wepdecrypt/wepdecrypt-0.7.ebuild,v 1.5 2007/07/15 03:28:52 mr_bones_ Exp $

inherit eutils

MY_P="WepDecrypt-${PV}"
DESCRIPTION="Enhanced version of WepAttack a tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepdecrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepdecrypt/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#Please don't add ppc as wepdecrypt doesn't work under ppc
KEYWORDS="~ppc ~x86"
IUSE="X"

RDEPEND="X? ( >=x11-libs/fltk-1.1.6 )
	sys-libs/zlib
	net-libs/libpcap
	dev-libs/openssl"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-makefile.patch
}

src_compile() {
	local conf
	if ! use X
	then
		conf=--disable-gui
	fi
	econf ${conf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/wepdecrypt run/wepdecrypt_{inc,word} || die

	if use X; then
		dobin src/gwepdecrypt || die
	fi

	insinto /etc
	doins conf/wepdecrypt.conf
	doman doc/wepdecrypt.1.gz
	dodoc CHANGELOG README doc/manual.html doc/manual.txt
}
