# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/dboxfe/dboxfe-0.0.3.ebuild,v 1.4 2005/03/17 19:49:56 mr_bones_ Exp $

inherit kde

DESCRIPTION="Creates and manages configuration files for DOSBox"
HOMEPAGE="http://dboxfe.linuxmind.de/"
SRC_URI="http://download.berlios.de/dboxfe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND=">=games-emulation/dosbox-0.61"

need-kde 3.1
need-qt 3.2

S="${WORKDIR}/${P}.0.61"
