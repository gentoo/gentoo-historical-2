# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lineak-kdeplugins/lineak-kdeplugins-0.8.3.ebuild,v 1.1 2005/03/12 14:24:49 genstef Exp $

inherit kde

MY_PV=${PV/_/}
MY_P=${PN/-/_}-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="KDE plugins for LINEAK"
HOMEPAGE="http://lineak.sourceforge.net/"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

RDEPEND=">x11-misc/lineakd-0.8"

need-kde 3.2
