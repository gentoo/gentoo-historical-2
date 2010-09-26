# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/bkodama/bkodama-0.2.1.ebuild,v 1.1 2010/09/26 12:00:29 dilfridge Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="A friendly, yet very simple-minded Kodama (Japanese ghost) wandering on your desktop"
HOMEPAGE="http://kde-look.org/content/show.php/bkodama?content=106528"
SRC_URI="http://kde-look.org/CONTENT/content-files/106528-${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	media-sound/phonon
"
RDEPEND="${DEPEND}
	>=kde-base/plasma-workspace-${KDE_MINIMAL}
"
