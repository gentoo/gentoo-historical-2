# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/cherokee/cherokee-0.4.0.ebuild,v 1.1 2003/01/11 16:00:12 bass Exp $

S="${WORKDIR}/cherokee-0.4.0"
DESCRIPTION="An extremely fast and tiny web server."
SRC_URI="ftp://laurel.datsi.fi.upm.es/pub/linux/cherokee/${P}-beta5.tar.gz"
HOMEPAGE="http://www.alobbs.com/cherokee"
LICENSE="GPL-2"
DEPEND="sys-libs/glibc"
RDEPEND="${DEPEND}"
KEYWORDS="~x86"
SLOT="0"

src_compile() {
	econf
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
}
