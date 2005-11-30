# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/io_lib/io_lib-1.8.12b.ebuild,v 1.1.1.1 2005/11/30 10:09:19 chriswhite Exp $

DESCRIPTION="A general purpose trace and experiment file reading/writing interface"
HOMEPAGE="http://staden.sourceforge.net/"
SRC_URI="mirror://sourceforge/staden/${P}.tar.bz2"
LICENSE="staden"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${PN}-1.8.12

src_install() {
	make install DESTDIR=${D} || die
	dodoc CHANGES NEWS README
}
