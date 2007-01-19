# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/new/new-1.3.5.ebuild,v 1.2 2007/01/19 20:46:42 armin76 Exp $

inherit eutils

DESCRIPTION="template system useful when used with a simple text editor (like vi)"
HOMEPAGE="http://www.flyn.org/"
SRC_URI="http://www.flyn.org/projects/new/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO
}
