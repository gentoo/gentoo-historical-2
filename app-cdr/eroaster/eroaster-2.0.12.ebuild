# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/eroaster/eroaster-2.0.12.ebuild,v 1.7 2003/02/13 06:11:19 vapier Exp $

DESCRIPTION="Awesome CD burning frontend"
SRC_URI="ftp://eclipt.uni-klu.ac.at/pub/projects/eroaster/${P}.tar.gz"
HOMEPAGE="http://eclipt.uni-klu.ac.at/eroaster.php"

LICENSE="GPL-2"
KEYWORDS="x86 ppc"
SLOT="0"

DEPEND=">=dev-lang/python-2.0
	app-cdr/cdrtools
	dev-python/gnome-python"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
