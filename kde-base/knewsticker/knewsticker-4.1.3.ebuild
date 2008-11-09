# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knewsticker/knewsticker-4.1.3.ebuild,v 1.1 2008/11/09 02:11:20 scarabeus Exp $

EAPI="2"

KMNAME=kdenetwork
inherit kde4-meta

DESCRIPTION="Plasma widget: rss news ticker"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="kde-base/libplasma:${SLOT}"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs} -DWITH_Plasma=ON"

	kde4-meta_src_configure
}
