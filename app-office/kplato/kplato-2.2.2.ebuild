# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kplato/kplato-2.2.2.ebuild,v 1.2 2010/10/15 21:55:47 dilfridge Exp $

EAPI="2"

KMNAME="koffice"
KMMODULE="${PN}"
inherit kde4-meta

DESCRIPTION="KPlato is a project management application."

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~app-office/kchart-${PV}:${SLOT}[reports]"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libs/"
KMEXTRA="
	filters/${KMMODULE}/
	kdgantt/
"
KMLOADLIBS="koffice-libs"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with python PythonLibs)
		-DBUILD_kplato=ON
	)

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	# this is already installed by koffice-data
	rm -f "${D}/usr/include/config-opengl.h"
}
