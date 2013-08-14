# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dolphin/dolphin-4.11.0.ebuild,v 1.1 2013/08/14 20:24:24 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="A KDE filemanager focusing on usability"
HOMEPAGE="http://dolphin.kde.org http://www.kde.org/applications/system/dolphin"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug thumbnail"

DEPEND="
	$(add_kdebase_dep kactivities)
	$(add_kdebase_dep libkonq)
	$(add_kdebase_dep nepomuk-core)
	$(add_kdebase_dep nepomuk-widgets)
	>=dev-libs/shared-desktop-ontologies-0.11.0
	dev-libs/soprano
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kfind)
"
PDEPEND="
	thumbnail? (
		$(add_kdebase_dep thumbnailers)
		|| (
			$(add_kdebase_dep ffmpegthumbs)
			$(add_kdebase_dep mplayerthumbs)
		)
	)
"

KMLOADLIBS="libkonq"

RESTRICT="test"
# bug 393129

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version media-gfx/icoutils ; then
		elog "For .exe file preview support, install media-gfx/icoutils."
	fi
}
