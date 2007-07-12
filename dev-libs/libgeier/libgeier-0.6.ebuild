# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgeier/libgeier-0.6.ebuild,v 1.3 2007/07/12 02:25:34 mr_bones_ Exp $

inherit versionator

MY_PVD=$(get_version_component_range 1-2)
MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Libgeier provides a library to access the german digital tax project ELSTER."
HOMEPAGE="http://www.taxbird.de/"

SRC_URI="http://www.taxbird.de/download/${PN}/${MY_PVD}/${PN}-${MY_PV}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="
dev-libs/openssl
dev-libs/libxml2
dev-libs/libxslt
dev-libs/xmlsec
sys-libs/zlib"

src_compile() {

	econf || die "Configure failed!"
	emake || die "Make failed!"

}

src_install() {

	dodoc README

	einstall || die "Installation failed!"

}
