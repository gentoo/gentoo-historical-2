# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/geomview/geomview-1.8.1-r3.ebuild,v 1.5 2004/06/24 22:00:10 agriffis Exp $

inherit eutils flag-o-matic

DESCRIPTION="Interactive Geometry Viewer"
SRC_URI="http://ftp1.sourceforge.net/geomview/geomview-1.8.1.tar.gz"
HOMEPAGE="http://geomview.sourceforge.net"

KEYWORDS="~x86 ~sparc ~ppc"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="dev-lang/tk
	x11-libs/xforms
	x11-libs/lesstif
	virtual/opengl"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-stdiostream.diff
	epatch ${FILESDIR}/${P}-configure.diff
}

src_compile() {
	append-flags "-DGL_GLEXT_LEGACY"
	econf || die "could not configure"
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install
}
