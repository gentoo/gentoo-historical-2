# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unace/unace-2.2.ebuild,v 1.13 2005/01/01 11:59:26 eradicator Exp $

DESCRIPTION="ACE unarchiver"
HOMEPAGE="http://www.winace.com/"
SRC_URI="http://www.maxeline.com/winace/linunace${PV//.}.tgz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* x86 amd64 s390"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}

src_install() {
	into /opt
	dobin unace || die
}
