# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/positron/positron-1.0.ebuild,v 1.6 2003/10/20 09:57:39 lanius Exp $

DESCRIPTION="Synchronization manager for the Neuros Audio Computer (www.neurosaudio.com) portable music player."
HOMEPAGE="http://www.xiph.org/positron"
SRC_URI="http://www.xiph.org/positron/files/source/${P}.tar.gz"
LICENSE="xiph"
SLOT="0"

KEYWORDS="x86 ppc"
IUSE=""
DEPEND=">=dev-lang/python-2.2"

RDEPEND="${DEPEND}
	oggvorbis? (
		dev-python/pyvorbis
	)"

src_compile() {
	einfo "No compilation required"
}

src_install() {
	chmod +x setup.py
	./setup.py install --root ${D} || die
}
