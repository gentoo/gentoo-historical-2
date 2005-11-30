# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpcube/ftpcube-0.4.2.ebuild,v 1.1 2003/04/02 21:36:11 liquidx Exp $

IUSE=""

inherit distutils

S="${WORKDIR}/${P}"
DESCRIPTION="Graphical FTP client using wxPython"
SRC_URI="mirror://sourceforge/ftpcube/${P}.tar.gz"
HOMEPAGE="http://ftpcube.sourceforge.net/"
DEPEND="virtual/python
	>=dev-python/wxPython-2.4.0.2"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~sparc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch || die "patch failed"
}
