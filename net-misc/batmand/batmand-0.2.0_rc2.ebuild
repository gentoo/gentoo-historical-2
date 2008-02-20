# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/batmand/batmand-0.2.0_rc2.ebuild,v 1.3 2008/02/20 10:53:27 cedk Exp $

inherit versionator eutils toolchain-funcs

MY_PV="$(delete_version_separator 3 )-rv422_sources"

DESCRIPTION="Better approach to mobile Ad-Hoc networking"
HOMEPAGE="http://open-mesh.net/batman"
SRC_URI="http://downloads.open-mesh.net/batman/stable/sources/${PN}_${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}_${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/CFLAGS =.*-Wall -O1 -g3/CFLAGS += -Wall/" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dosbin batmand

	newinitd "${FILESDIR}"/batmand-init.d batmand
	newconfd "${FILESDIR}"/batmand-conf.d batmand

	dodoc CHANGELOG
}
