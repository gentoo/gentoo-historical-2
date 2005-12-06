# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ghemical/ghemical-1.91.ebuild,v 1.1 2005/12/06 11:05:17 spyderous Exp $

inherit eutils

DESCRIPTION="Ghemical supports both quantum-mechanics (semi-empirical and ab initio) models and molecular mechanics models (there is an experimental Tripos 5.2-like force field for organic molecules). Also a tool for reduced protein models is included. Geometry optimization, molecular dynamics and a large set of visualization tools are currently available."
HOMEPAGE="http://www.uku.fi/~thassine/ghemical/"
SRC_URI="http://www.uku.fi/~thassine/ghemical/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="threads"

RDEPEND="virtual/glut
	>=x11-libs/gtkglext-1.0.5
	>=gnome-base/libglade-2.4.0
	>=sci-libs/libghemical-1.90
	threads? ( >=dev-libs/glib-2.4.0 )
	|| ( (
			media-libs/mesa
			x11-libs/libXmu
			x11-libs/libICE
		)
		virtual/x11
	)"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc3.4-r1.patch
	epatch ${FILESDIR}/${P}-ghemical-server-fix.patch
}

src_compile() {
	./configure \
		--prefix=/usr \
		$(use_enable threads) || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	sed -e "s:^prefix=.*:prefix=${D}/usr:" -i Makefile
	make install || die "Install failed"
}
