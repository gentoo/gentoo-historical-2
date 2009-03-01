# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/aircrack-ng/aircrack-ng-1.0_rc2.ebuild,v 1.1 2009/03/01 16:57:50 patrick Exp $

EAPI=1
inherit versionator eutils toolchain-funcs

MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"
SRC_URI="http://download.aircrack-ng.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sqlite"

DEPEND="dev-libs/openssl
	sqlite? ( >=dev-db/sqlite-3.4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

have_sqlite() {
	use sqlite && echo "true" || echo "false"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/sha-compile-fix-64bit.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" sqlite=$(have_sqlite) || die "emake failed"
}

src_install() {
	emake \
		prefix="/usr" \
		mandir="/usr/share/man/man1" \
		DESTDIR="${D}" \
		sqlite=$(have_sqlite) \
		install \
		|| die "emake install failed"

	dodoc AUTHORS ChangeLog README
}
