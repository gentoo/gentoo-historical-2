# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyserial/pyserial-1.18.ebuild,v 1.2 2003/04/04 23:28:26 liquidx Exp $
inherit distutils

S=${WORKDIR}/${P}
DESCRIPTION="Python Serial Port Extension"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
HOMEPAGE="http://pyserial.sourceforge.net"
IUSE=""
SLOT="0"
LICENSE="PYTHON"
KEYWORDS="x86"

DEPEND="virtual/python"
