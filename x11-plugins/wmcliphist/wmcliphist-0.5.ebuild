# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcliphist/wmcliphist-0.5.ebuild,v 1.7 2004/06/24 23:06:28 agriffis Exp $

IUSE=""
DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="http://linux.nawebu.cz/wmcliphist/"
SRC_URI="http://linux.nawebu.cz/wmcliphist/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~sparc ppc"
SLOT="0"

DEPEND="=x11-libs/gtk+-1.2*"

src_install() {
	dobin wmcliphist
	dodoc ChangeLog README
	newdoc .wmcliphistrc wmcliphistrc.sample
}
