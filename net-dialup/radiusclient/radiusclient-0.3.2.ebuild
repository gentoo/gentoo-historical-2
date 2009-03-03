# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/radiusclient/radiusclient-0.3.2.ebuild,v 1.23 2009/03/03 21:04:24 mrness Exp $

inherit eutils autotools

DESCRIPTION="A library for writing RADIUS clients accompanied with several client utilities."
HOMEPAGE="http://freshmeat.net/projects/radiusclient/"
SRC_URI="ftp://ftp.cityline.net/pub/radiusclient/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="!net-dialup/radiusclient-ng
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/pkgsysconfdir-install.patch"
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README BUGS CHANGES COPYRIGHT
	dohtml doc/instop.html
}
