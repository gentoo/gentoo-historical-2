# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pv/pv-0.8.1.ebuild,v 1.4 2004/06/24 22:29:27 agriffis Exp $

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="http://www.ivarch.com/programs/pv.shtml"
SRC_URI="mirror://sourceforge/pipeviewer/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""
DEPEND="virtual/glibc"

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}
src_install() {
	make DESTDIR=${D} UNINSTALL=/bin/true install || die "install failed"
}
