# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/katepart/katepart-4.7.3.ebuild,v 1.4 2011/12/07 10:21:15 phajdan.jr Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kate"
KMMODULE="part"
KDE_SCM="git"
inherit kde4-meta

DESCRIPTION="KDE Editor KPart"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 x86"
IUSE="debug"

RESTRICT="test"
# bug 392993

add_blocker kdelibs 4.6.50

src_configure() {
	local mycmakeargs=(
		"-DKDE4_BUILD_TESTS=OFF"
	)

	kde4-meta_src_configure
}
