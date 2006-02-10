# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bcpp/bcpp-20050725.ebuild,v 1.4 2006/02/10 05:21:34 deltacow Exp $

DESCRIPTION="Indents C/C++ source code"
HOMEPAGE="http://invisible-island.net/bcpp/"
SRC_URI="ftp://invisible-island.net/bcpp/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	make DESTDIR=${D} install || die
	dodoc CHANGES MANIFEST README VERSION txtdocs/hirachy.txt \
		txtdocs/manual.txt

	# install our configuration files
	insinto /etc/bcpp
	doins bcpp.cfg indent.cfg
}

pkg_postinst() {
	einfo "Check the documentation for more information on how to"
	einfo "Run bcpp.  Please note that in order to get help for"
	einfo "bcpp, please run bcpp -h and not the command by itself."
	einfo ""
	einfo "Configuration files are at /etc/bcpp."
	einfo "To use them, use the -c option followed by the filename."
}
