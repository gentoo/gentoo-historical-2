# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrypto/pycrypto-1.9_alpha6.ebuild,v 1.14 2004/06/25 01:38:38 agriffis Exp $

inherit distutils
IUSE=""

DESCRIPTION="Python cryptography toolkit."
HOMEPAGE="http://www.amk.ca/python/code/crypto.html"
SRC_URI="http://www.amk.ca/files/python/crypto/${P/_alpha/a}.tar.gz"
LICENSE="freedist"

DEPEND="virtual/glibc
	dev-lang/python"

SLOT="0"
KEYWORDS="x86 alpha ~sparc amd64 ~ppc"
S="${WORKDIR}/${P/_alpha/a}"
IUSE=""

mydoc="ACKS ChangeLog LICENSE MANIFEST PKG-INFO README TODO"
