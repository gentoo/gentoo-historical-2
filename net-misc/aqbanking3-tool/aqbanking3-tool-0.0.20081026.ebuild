# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/aqbanking3-tool/aqbanking3-tool-0.0.20081026.ebuild,v 1.1 2008/11/05 09:04:16 hanno Exp $

inherit eutils

DESCRIPTION="Free commandline tool for aqbanking."
HOMEPAGE="http://peter.schlaile.de/aqbanking/"
SRC_URI="mirror://gentoo/${P}.tar.lzma"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=net-libs/aqbanking-3.0"
S="${WORKDIR}/${PN}"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed"
}
