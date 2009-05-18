# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyserial/pyserial-2.4.ebuild,v 1.4 2009/05/18 19:19:34 gentoofan23 Exp $

inherit distutils

DESCRIPTION="Python Serial Port Extension"
HOMEPAGE="http://pyserial.wiki.sourceforge.net/pySerial"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES.txt"
PYTHON_MODNAME="serial"
