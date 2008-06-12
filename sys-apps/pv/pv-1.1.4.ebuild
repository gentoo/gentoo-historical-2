# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pv/pv-1.1.4.ebuild,v 1.4 2008/06/12 18:46:03 armin76 Exp $

DESCRIPTION="Pipe Viewer: a tool for monitoring the progress of data through a pipe"
HOMEPAGE="http://www.ivarch.com/programs/pv.shtml"
SRC_URI="mirror://sourceforge/pipeviewer/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"
IUSE="debug nls"

src_compile() {
	econf \
		$(use_enable debug debugging) \
		$(use_enable nls) \
		|| die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc README doc/NEWS doc/TODO
}
