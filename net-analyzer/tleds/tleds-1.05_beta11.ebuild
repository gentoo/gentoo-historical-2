# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tleds/tleds-1.05_beta11.ebuild,v 1.14 2005/01/17 20:38:52 luckyduck Exp $

inherit eutils

MY_P=${P/_/}
S=${WORKDIR}/${MY_P/eta11/}
DESCRIPTION="Blinks keyboard LEDs indicating outgoing and incoming network packets on selected network interface"
HOMEPAGE="http://www.hut.fi/~jlohikos/tleds_orig.html"
SRC_URI="http://www.hut.fi/~jlohikos/tleds/public/${MY_P/11/10}.tgz
	http://www.hut.fi/~jlohikos/tleds/public/${MY_P}.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~amd64"
IUSE="X"

DEPEND="X? ( virtual/x11 )"

src_unpack() {
	unpack tleds-1.05beta10.tgz
	cd ${S}
	epatch ${DISTDIR}/${MY_P}.patch.bz2
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	if use X ; then
		emake all || die "make failed :("
	else
		emake tleds || die "make tleds failed :("
	fi
}

src_install() {
	dosbin tleds
	use X && dosbin xtleds

	doman tleds.1
	dodoc README COPYING Changes

	exeinto /etc/init.d
	newexe ${FILESDIR}/tleds.init.d tleds
	insinto /etc/conf.d
	newins ${FILESDIR}/tleds.conf.d tleds
}
