# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gshisen/gshisen-1.3.0.ebuild,v 1.2 2010/08/22 12:51:10 maekke Exp $

inherit eutils gnustep-2

MY_PN=GShisen
DESCRIPTION="The first GNUstep game, similar to Mahjongg"
HOMEPAGE="http://gap.nongnu.org/gshisen/index.html"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${MY_PN}-${PV}
