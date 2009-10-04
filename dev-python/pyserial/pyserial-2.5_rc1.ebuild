# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyserial/pyserial-2.5_rc1.ebuild,v 1.3 2009/10/04 19:57:37 klausman Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_P="${P/_/-}"

DESCRIPTION="Python Serial Port Extension"
HOMEPAGE="http://pyserial.wiki.sourceforge.net/pySerial"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="CHANGES.txt"
PYTHON_MODNAME="serial"

S="${WORKDIR}/${MY_P}"
