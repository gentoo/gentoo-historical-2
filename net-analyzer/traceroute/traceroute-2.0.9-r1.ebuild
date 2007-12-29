# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/traceroute/traceroute-2.0.9-r1.ebuild,v 1.4 2007/12/29 16:03:15 rich0 Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Utility to trace the route of IP packets"
HOMEPAGE="http://dmitry.butskoy.name/traceroute"
SRC_URI="http://www.odu.neva.ru/buc/traceroute/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh sparc x86"
IUSE="static"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.0.8-prestrip.patch
	epatch "${FILESDIR}"/${PN}-2.0.8-man.patch
	use static && append-ldflags -static
}

src_compile() {
	tc-export CC AR RANLIB
	emake env=yes || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="/usr" \
		libdir="/usr/$(get_libdir)" \
		install \
		|| die

	doman traceroute/traceroute.8
	dodoc ChangeLog CREDITS README TODO
}
