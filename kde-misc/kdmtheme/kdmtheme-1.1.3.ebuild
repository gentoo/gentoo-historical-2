# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kdmtheme/kdmtheme-1.1.3.ebuild,v 1.1 2007/05/06 14:35:04 carlo Exp $

inherit kde

DESCRIPTION="KDM Theme Manager is a Control Center module for changing KDM theme"
HOMEPAGE="http://beta.smileaf.org/"
SRC_URI="http://beta.smileaf.org/files/kdmtheme/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""
SLOT="0"

need-kde 3.5
