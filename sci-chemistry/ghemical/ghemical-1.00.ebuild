# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/ghemical/ghemical-1.00.ebuild,v 1.2 2004/12/24 16:50:58 ribosome Exp $

DESCRIPTION="Ghemical supports both quantum-mechanics (semi-empirical and ab initio) models and molecular mechanics models (there is an experimental Tripos 5.2-like force field for organic molecules). Also a tool for reduced protein models is included. Geometry optimization, molecular dynamics and a large set of visualization tools are currently available."
HOMEPAGE="http://www.uku.fi/~thassine/ghemical/"
SRC_URI="http://www.uku.fi/~thassine/ghemical/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="gnome-base/gnome-libs
	dev-libs/libf2c
	sci-chemistry/mpqc
	=x11-libs/gtkglarea-1.2*
	>=media-libs/glut-3.7
	dev-libs/libxml
	=gnome-base/libglade-0*"

src_compile() {
	./configure --prefix=/usr --enable-mpqc ||die
	emake ||die
}

src_install() {
	sed -e "s:^prefix=.*:prefix=${D}/usr:" -i Makefile
	make install||die
}
