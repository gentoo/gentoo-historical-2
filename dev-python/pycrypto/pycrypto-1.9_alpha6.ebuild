# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycrypto/pycrypto-1.9_alpha6.ebuild,v 1.1.1.1 2005/11/30 10:10:29 chriswhite Exp $

inherit distutils

DESCRIPTION="Python cryptography toolkit."
HOMEPAGE="http://www.amk.ca/python/code/crypto.html"
SRC_URI="http://www.amk.ca/files/python/crypto/${P/_alpha/a}.tar.gz"
LICENSE="freedist"

DEPEND="virtual/libc
	dev-lang/python"

SLOT="0"
KEYWORDS="x86 alpha ~sparc amd64 ppc"
S="${WORKDIR}/${P/_alpha/a}"
IUSE=""

mydoc="ACKS ChangeLog LICENSE MANIFEST PKG-INFO README TODO"
