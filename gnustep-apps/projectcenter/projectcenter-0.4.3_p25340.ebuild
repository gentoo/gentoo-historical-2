# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/projectcenter/projectcenter-0.4.3_p25340.ebuild,v 1.4 2008/03/08 13:41:02 coldwind Exp $

inherit gnustep-2

S=${WORKDIR}/${P/projectc/ProjectC}

DESCRIPTION="An IDE for GNUstep."
HOMEPAGE="http://www.gnustep.org/experience/ProjectCenter.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

KEYWORDS="amd64 ppc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"

RDEPEND=">=sys-devel/gdb-6.0"
