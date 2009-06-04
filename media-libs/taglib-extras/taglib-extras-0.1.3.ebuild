# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib-extras/taglib-extras-0.1.3.ebuild,v 1.2 2009/06/04 20:03:44 tampakrap Exp $

EAPI="2"

KMNAME="kdesupport"
KDE_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Unofficial taglib plugins maintained by the Amarok team"
HOMEPAGE="http://developer.kde.org/~wheeler/taglib.html"
SRC_URI="http://www.kollide.net/~jefferai/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

RDEPEND="
	>=media-libs/taglib-1.5
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with kde KDE)"

	kde4-base_src_configure
}
