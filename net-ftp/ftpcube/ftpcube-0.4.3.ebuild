# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftpcube/ftpcube-0.4.3.ebuild,v 1.7 2004/05/04 11:34:44 kloeri Exp $

IUSE=""

inherit distutils virtualx eutils

DESCRIPTION="Graphical FTP client using wxPython"
SRC_URI="mirror://sourceforge/ftpcube/${P}.tar.gz"
HOMEPAGE="http://ftpcube.sourceforge.net/"
DEPEND="virtual/python
	>=dev-python/wxPython-2.4.0.2"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~sparc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch || die "patch failed"
}

src_compile() {
	export maketype=distutils_src_compile
	virtualmake
}

src_install() {
	export maketype=distutils_src_install
	virtualmake
}
