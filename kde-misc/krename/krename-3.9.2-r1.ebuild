# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krename/krename-3.9.2-r1.ebuild,v 1.3 2009/04/06 11:45:41 scarabeus Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="KRename - a very powerful batch file renamer."
HOMEPAGE="http://www.krename.net/"
SRC_URI="mirror://sourceforge/krename/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/taglib-1.5"
RDEPEND="${DEPEND}
	!kde-misc/krename:0
"
