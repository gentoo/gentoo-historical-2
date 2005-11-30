# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bcpp/bcpp-20030423.ebuild,v 1.1 2003/08/10 14:10:13 jhhudso Exp $

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
	einstall || die
	dodoc CHANGES MANIFEST README VERSION txtdocs/hirachy.txt \
	      txtdocs/manual.txt
}
