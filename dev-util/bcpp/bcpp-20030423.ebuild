# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bcpp/bcpp-20030423.ebuild,v 1.3 2003/11/19 18:00:29 mholzer Exp $

DESCRIPTION="Indents C/C++ source code"
HOMEPAGE="http://invisible-island.net/bcpp/"
SRC_URI="ftp://invisible-island.net/bcpp/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""
RDEPEND=""
S=${WORKDIR}/${P}

src_install() {
	#einstall || die
	make DESTDIR=${D} install || die
	dodoc CHANGES MANIFEST README VERSION txtdocs/hirachy.txt \
		txtdocs/manual.txt bcpp.cfg
}
