# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kshutdown/kshutdown-0.8.ebuild,v 1.3 2005/12/08 00:26:18 cryos Exp $

inherit kde

DESCRIPTION="A shutdown manager for KDE"
HOMEPAGE="http://kshutdown.sourceforge.net"
SRC_URI="mirror://sourceforge/kshutdown/${P}.tar.bz2"
LICENSE="GPL-2"

IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

RDEPEND="|| ( ( kde-base/kdesu kde-base/kcontrol kde-base/kdialog )
	      kde-base/kdebase )"

need-kde 3.4
