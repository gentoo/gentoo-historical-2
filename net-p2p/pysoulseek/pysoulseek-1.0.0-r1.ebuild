# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/pysoulseek/pysoulseek-1.0.0-r1.ebuild,v 1.3 2003/03/16 17:31:00 liquidx Exp $

IUSE="oggvorbis"

inherit eutils

MY_PN="${PN/soulseek/slsk}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="client for SoulSeek filesharing"
HOMEPAGE="http://www.sensi.org/~ak/pyslsk/"
SRC_URI="http://www.sensi.org/~ak/pyslsk/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND=">=dev-lang/python-2.1
	>=dev-python/wxPython-2.4.0.1
	~x11-libs/wxGTK-2.4.0
	oggvorbis? ( media-libs/pyvorbis media-libs/pyogg )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	epatch ${FILESDIR}/${P}-hyriand-11.patch
	python setup.py build || die "compile failed"
}

src_install() {
	python setup.py install --prefix=/usr --root=${D} || die "install failed"
	dodoc CHANGELOG KNOWN_BUGS MAINTAINERS MANIFEST PKG-INFO README TODO VERSION
}
