# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kpresenter/kpresenter-2.2.2.ebuild,v 1.1 2010/09/25 20:38:59 dilfridge Exp $

EAPI="2"

KMNAME="koffice"
KMMODULE="${PN}"
inherit kde4-meta

DESCRIPTION="KOffice presentation program."

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-libs/boost-1.35.0"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	filters/libmsooxml/
	libs/
"
KMEXTRA="
	filters/${KMMODULE}/
	filters/libmso/
"

KMLOADLIBS="koffice-libs"

src_install() {
	kde4-meta_src_install

	# this is already installed by koffice-data
	rm -f "${D}/usr/include/config-opengl.h"
}
