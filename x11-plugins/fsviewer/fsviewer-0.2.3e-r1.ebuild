# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/fsviewer/fsviewer-0.2.3e-r1.ebuild,v 1.3 2004/06/24 22:52:01 agriffis Exp $

DESCRIPTION="file system viewer for Window Maker"
HOMEPAGE="http://www.bayernline.de/~gscholz/linux/fsviewer/"
SRC_URI="http://www.bayernline.de/~gscholz/linux/fsviewer/${PN}.app-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

IUSE=""

DEPEND="x11-wm/windowmaker"

S="${WORKDIR}/${PN}.app-${PV}"

src_compile() {

	econf --with-appspath=/usr/lib/GNUstep \
		|| die "configure failed"

	emake || die "parallel make failed"

}

src_install() {

	make DESTDIR=${D} install || die "make install failed"

}
