# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/proj/proj-4.4.8.ebuild,v 1.3 2004/12/15 22:19:39 kloeri Exp $

inherit eutils

N=${S}/nad
DESCRIPTION="Proj.4 cartographic projection software with extra NAD27 grids"
HOMEPAGE="http://proj.maptools.org/"
SRC_URI="ftp://ftp.remotesensing.org/pub/proj/${P}.tar.gz
	http://proj.maptools.org/dl/proj-nad27-1.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ppc ~sparc alpha ~mips ~hppa ~amd64"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/proj-4.4.7-gentoo.patch || die
	cd ${N}
	mv README README.NAD
	unpack proj-nad27-1.1.tar.gz || die
}

src_install() {
	einstall || die
	insinto /usr/share/proj
	insopts -m 755
	doins nad/test27
	doins nad/test83
	insopts -m 644
	doins nad/pj_out27.dist
	doins nad/pj_out83.dist
	dodoc README NEWS AUTHORS INSTALL ChangeLog ${N}/README.NAD ${N}/README.NADUS
}
