# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/kdar/kdar-1.0.0.ebuild,v 1.4 2004/07/06 12:12:00 carlo Exp $

inherit kde

MY_P=${P/_/"-"}
S=${WORKDIR}/${MY_P}

DESCRIPTION="the KDE Disk Archiver"
HOMEPAGE="http://kdar.sourceforge.net/"
SRC_URI="mirror://sourceforge/kdar/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND=">=app-arch/dar-2.1.0"
RDEPEND=">=app-arch/dar-2.1.0"
need-kde 3.1