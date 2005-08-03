# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/reinhardtstyle/reinhardtstyle-0.8.2.ebuild,v 1.4 2005/08/03 18:25:18 gustavoz Exp $

inherit kde
need-kde 3.2

# kde-look.org prefixes filenames
MY_PN="5962-reinhardtstyle"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Minimalistic KDE style heavily based on clee's dotNET"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5962"
SRC_URI="http://www.kde-look.org/content/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc"
IUSE=""
