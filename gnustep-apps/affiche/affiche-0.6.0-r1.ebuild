# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/affiche/affiche-0.6.0-r1.ebuild,v 1.2 2004/10/14 20:00:51 dholm Exp $

inherit gnustep

S=${WORKDIR}/${PN/a/A}

DESCRIPTION="Affiche allows people to 'stick' notes"
HOMEPAGE="http://www.collaboration-world.com/cgi-bin/collaboration-world/project/release.cgi?pid=5"
SRC_URI="http://www.collaboration-world.com/affiche.data/releases/Stable/${P/a/A}.tar.gz"
KEYWORDS="~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

