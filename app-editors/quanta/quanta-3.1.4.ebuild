# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/quanta/quanta-3.1.4.ebuild,v 1.4 2004/01/19 14:58:11 caleb Exp $

inherit kde

need-kde 3.1

DESCRIPTION="A superb web development tool for KDE 3.x"
SRC_URI="mirror://kde/stable/${PV}/src/${P}.tar.bz2
	 mirror://sourceforge/quanta/css.tar.bz2
	 mirror://sourceforge/quanta/html.tar.bz2
	 mirror://sourceforge/quanta/javascript.tar.bz2
	 mirror://sourceforge/quanta/php.tar.bz2"
HOMEPAGE="http://quanta.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc"

src_install() {
	kde_src_install

	dodir ${PREFIX}/share/apps/quanta/doc/
	for x in css html javascript php ; do
		cp -a ${WORKDIR}/${x}/*.docrc ${WORKDIR}/${x}/${x} ${D}/${PREFIX}/share/apps/quanta/doc/
	done
}
