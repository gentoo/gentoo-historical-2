# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/krusader/krusader-1.40_beta1.ebuild,v 1.3 2004/06/24 22:20:26 agriffis Exp $

IUSE=""

inherit kde
need-kde 3

MY_P=${P/_/"-"}
S=${WORKDIR}/${MY_P}

DESCRIPTION="An advanced twin-panel (commander-style) file-manager for KDE 3.x with many extras"
HOMEPAGE="http://krusader.sourceforge.net/"
SRC_URI="mirror://sourceforge/krusader/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc"
