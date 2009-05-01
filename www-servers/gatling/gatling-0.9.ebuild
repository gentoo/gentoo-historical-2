# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/gatling/gatling-0.9.ebuild,v 1.1 2009/05/01 12:23:29 patrick Exp $

inherit eutils

DESCRIPTION="high performance web server"
HOMEPAGE="http://www.fefe.de/gatling/"
SRC_URI="http://dl.fefe.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libowfat
	dev-libs/dietlibc"
RDEPEND=""

src_unpack() {
	unpack $A
	cd "${S}"

	epatch "${FILESDIR}/gentoo-vars.patch"
}

src_compile() {
	emake gatling || die "emake gatling failed"
}

src_install() {
	dobin gatling || die "installing binary failed"
	doman gatling.1 || die "installing manpage failed"
}
