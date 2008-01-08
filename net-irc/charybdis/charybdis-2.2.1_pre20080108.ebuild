# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/charybdis/charybdis-2.2.1_pre20080108.ebuild,v 1.2 2008/01/08 14:24:09 jokey Exp $

inherit eutils

DESCRIPTION="A non-monolithic ircd loosely based on ircd-ratbox"
HOMEPAGE="http://www.ircd-charybdis.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ipv6 ssl debug smallnet zlib static"

DEPEND="zlib? ( sys-libs/zlib )
	ssl? ( dev-libs/openssl )
	!net-irc/ircd-hybrid"

pkg_setup() {
	enewuser ircd
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-dircreate.patch
}

src_compile() {
	econf \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		$(use_enable debug assert) \
		$(use_enable smallnet small-net) \
		$(use_enable zlib) \
		$(use_enable !static shared-modules) \
		--with-confdir=/etc/charybdis \
		--with-logdir=/var/log/charybdis \
		--with-helpdir=/usr/share/charybdis/help \
		--with-moduledir=/usr/lib/charybdis \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install
}
