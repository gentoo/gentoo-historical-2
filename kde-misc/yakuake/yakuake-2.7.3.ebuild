# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/yakuake/yakuake-2.7.3.ebuild,v 1.1.1.1 2005/11/30 09:57:12 chriswhite Exp $

inherit kde

DESCRIPTION="Yet another Kuake KDE terminal emulator"
HOMEPAGE="http://yakuake.uv.ro/"
SRC_URI="http://download.softpedia.com/linux/${P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( kde-base/konsole
	kde-base/kdebase )"

need-kde 3.3

