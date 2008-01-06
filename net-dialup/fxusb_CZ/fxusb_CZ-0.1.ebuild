# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/fxusb_CZ/fxusb_CZ-0.1.ebuild,v 1.1 2008/01/06 02:09:08 sbriesen Exp $

inherit eutils rpm linux-mod

DESCRIPTION="AVM kernel 2.6 modules for Fritz!X USB (Teledat Version)"
HOMEPAGE="http://opensuse.foehr-it.de/"
SRC_URI="http://opensuse.foehr-it.de/rpms/10_3/src/${P}-0.src.rpm"

LICENSE="AVM-FC"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="!net-dialup/fritzcapi"
RDEPEND="${DEPEND} net-dialup/capi4k-utils"

S="${WORKDIR}/fritz"

pkg_setup() {
	linux-mod_pkg_setup

	if ! kernel_is 2 6; then
		die "This package works only with 2.6 kernel!"
	fi

	BUILD_TARGETS="all"
	BUILD_PARAMS="KDIR=${KV_DIR} LIBDIR=${S}/src"
	MODULE_NAMES="${PN}(net:${S}/src)"
}

src_unpack() {
	rpm_unpack "${DISTDIR}/${A}" || die "failed to unpack ${A} file"
	DISTDIR="${WORKDIR}" unpack fxusb.tar.gz

	cd "${S}"
	epatch $(sed -n "s|^Patch[01234]:\s*\(.*\)|../\1|p" ../${PN}.spec)
	convert_to_m "src/Makefile"
}

src_install() {
	linux-mod_src_install
	dodoc CAPI*.txt README*
	dohtml *.html
}
