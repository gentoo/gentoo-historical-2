# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/dav/dav-0.8.5.ebuild,v 1.5 2005/01/01 13:22:52 eradicator Exp $

DESCRIPTION="A minimal console text editor"
HOMEPAGE="http://dav-text.sourceforge.net/"

# The maintainer does not keep sourceforge's mirrors up-to-date,
# so we point to the website's store of files.
SRC_URI="http://dav-text.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc"
IUSE=""

DEPEND="sys-libs/ncurses"

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="-lncurses ${CFLAGS}" || die
}

src_install() {
	emake DESTDIR=${D} install || die
}
