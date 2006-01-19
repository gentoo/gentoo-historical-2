# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tleds/tleds-1.05_beta11-r1.ebuild,v 1.1 2006/01/19 01:57:38 vanquirius Exp $

inherit eutils

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P/eta11/}"
DESCRIPTION="Blinks keyboard LEDs indicating outgoing and incoming network packets on selected network interface"
HOMEPAGE="http://www.hut.fi/~jlohikos/tleds_orig.html"
SRC_URI="http://www.hut.fi/~jlohikos/tleds/public/${MY_P/11/10}.tgz
	http://www.hut.fi/~jlohikos/tleds/public/${MY_P}.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="X"

DEPEND="X? (
	|| ( ( >=x11-libs/libX11-1.0.0 )
	virtual/x11 )
	)"

src_unpack() {
	unpack tleds-1.05beta10.tgz
	cd "${S}"
	epatch "${DISTDIR}"/${MY_P}.patch.bz2
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	if use X ; then
		emake all || die "make failed"
	else
		emake tleds || die "make tleds failed"
	fi
}

src_install() {
	dosbin tleds
	use X && dosbin xtleds

	doman tleds.1
	dodoc README Changes

	newinitd "${FILESDIR}"/tleds.init.d tleds
	newconfd "${FILESDIR}"/tleds.conf.d tleds
}
