# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat6/netcat6-1.0-r1.ebuild,v 1.8 2009/07/04 12:55:24 ranger Exp $

inherit eutils autotools

DESCRIPTION="netcat clone with better IPv6 support, improved code, etc..."
HOMEPAGE="http://netcat6.sourceforge.net/"
SRC_URI="ftp://ftp.deepspace6.net/pub/ds6/sources/nc6/nc6-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="ipv6 nls bluetooth"

DEPEND="bluetooth? ( || ( net-wireless/bluez net-wireless/bluez-libs ) )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/nc6-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/netcat6-1.0-unix-sockets.patch"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable ipv6) \
		$(use_enable bluetooth bluez) \
		$(use_enable nls)
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS README NEWS TODO CREDITS ChangeLog
}
