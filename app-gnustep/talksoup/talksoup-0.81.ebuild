# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-gnustep/talksoup/talksoup-0.81.ebuild,v 1.5 2004/07/22 21:45:21 fafhrd Exp $

inherit gnustep-old

need-gnustep-gui

DESCRIPTION="GNUstep based IRC Client"
HOMEPAGE="http://linuks.mine.nu/andy/talksoup/index.html"
LICENSE="GPL-2"
SRC_URI="http://linuks.mine.nu/andy/files/talksoup/TalkSoup-${PV}.tar.gz"
KEYWORDS="x86 ~ppc"
SLOT="0"
S=${WORKDIR}/TalkSoup-${PV}
IUSE=""
