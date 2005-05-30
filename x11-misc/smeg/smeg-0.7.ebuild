# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/smeg/smeg-0.7.ebuild,v 1.2 2005/05/30 16:32:00 lanius Exp $

DESCRIPTION="Simple Menu Editor for Gnome, written in Python"
HOMEPAGE="http://www.realistanew.com/projects/smeg/"
SRC_URI="http://dev.realistanew.com/smeg/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gnome"

DEPEND=">=dev-lang/python-2.4
	>=dev-python/pyxdg-0.12
	>=dev-python/gnome-python-2.6.1
	gnome? ( >=gnome-base/gnome-menus-2.10.1 )"

src_compile() {
	einfo "No compilation necessary"
}

src_install() {
	python setup.py install --prefix=${D}/usr || die
}
