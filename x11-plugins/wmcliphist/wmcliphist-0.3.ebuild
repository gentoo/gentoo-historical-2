# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcliphist/wmcliphist-0.3.ebuild,v 1.3 2004/04/30 22:25:21 pvdabeel Exp $

DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="http://linux.nawebu.cz/wmcliphist/"
SRC_URI="http://linux.nawebu.cz/wmcliphist/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc"
SLOT="0"

DEPEND="virtual/x11"

src_compile() {
	emake || die
}

src_install() {
	dobin wmcliphist
	dodoc ChangeLog README
	newdoc .wmcliphistrc wmcliphistrc.sample
}
