# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/karbon/karbon-2.1.0.ebuild,v 1.7 2010/06/21 13:58:55 ssuominen Exp $

EAPI="2"
KMNAME="koffice"
KMMODULE="${PN}"

inherit kde4-meta

DESCRIPTION="KOffice vector drawing application."

KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="+pstoedit wpg"

DEPEND="
	media-libs/libart_lgpl
	pstoedit? ( media-gfx/pstoedit )
	wpg? ( media-libs/libwpg )
"
RDEPEND="${DEPEND}"

KMEXTRA="filters/${KMMODULE}"
KMEXTRACTONLY="
	libs/
	plugins/
	filters/
"
KMLOADLIBS="koffice-libs"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with wpg)
		$(cmake-utils_use_with pstoedit)"
	kde4-meta_src_configure
}
