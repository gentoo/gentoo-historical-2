# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klipper/klipper-4.11.0.ebuild,v 1.1 2013/08/14 20:24:14 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="Applet for KDE and X clipboard management"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug prison"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libtaskmanager)
	sys-libs/zlib
	x11-libs/libX11
	prison? ( media-libs/prison )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with prison)
	)

	kde4-meta_src_configure
}
