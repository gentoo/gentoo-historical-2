# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/domino/domino-0.4-r1.ebuild,v 1.1 2008/11/07 23:51:43 scarabeus Exp $

ARTS_REQUIRED="never"
inherit kde

DESCRIPTION="A KDE style with a soft look"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=42804"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/42804-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""
EXTRA_ECONF="--prefix=/usr/kde/3.5/"

RDEPEND="|| ( =kde-base/kwin-3.5* =kde-base/kdebase-3.5* )"
need-kde 3.5

PATCHES=( "${FILESDIR}/${P}-fbsd.patch" )

src_unpack() {
	kde_src_unpack
	rm -f "${S}/configure"
}
