# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kpopup/kpopup-0.9.7.ebuild,v 1.2 2004/06/29 16:50:37 dholm Exp $

inherit kde

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="An SMB Network Messenger"
HOMEPAGE="http://www.henschelsoft.de/kpopup.html"
SRC_URI="http://www.henschelsoft.de/kpopup/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=net-fs/samba"
need-kde 3