# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/stunnel/stunnel-3.26.ebuild,v 1.10 2005/02/11 20:58:27 kaiowas Exp $

inherit eutils

DESCRIPTION="TLS/SSL - Port Wrapper"
HOMEPAGE="http://www.stunnel.org/"
SRC_URI="http://www.stunnel.org/download/stunnel/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc alpha ppc ~amd64 ~ppc-macos"
IUSE="selinux"

RDEPEND=">=dev-libs/openssl-0.9.6j
	selinux? ( sec-policy/selinux-stunnel )"
DEPEND="${RDEPEND}
	virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	if use ppc-macos ; then
		sed -i -e "s,-shared,-dynamic -flat_namespace -bundle -undefined suppress,g" \
			-e "s,stunnel.so,stunnel.dylib,g" \
			Makefile.in || die "sed failed"
	fi
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	dosbin stunnel
	dodoc FAQ README HISTORY COPYING BUGS PORTS TODO transproxy.txt
	doman stunnel.8
	if use ppc-macos ; then
		dolib.so stunnel.dylib
	else
		dolib.so stunnel.so
	fi
}
