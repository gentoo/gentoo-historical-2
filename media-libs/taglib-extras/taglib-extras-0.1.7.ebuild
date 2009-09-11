# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib-extras/taglib-extras-0.1.7.ebuild,v 1.1 2009/09/11 01:24:42 jmbsvicetto Exp $

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

TAGLIB_VERSION="1.5"
RDEPEND="
	>=media-libs/taglib-${TAGLIB_VERSION}
"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with kde)"

	kde4-base_src_configure
}
