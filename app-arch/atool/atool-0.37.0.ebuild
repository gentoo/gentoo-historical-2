# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/atool/atool-0.37.0.ebuild,v 1.1 2009/08/17 14:19:48 nyhm Exp $

DESCRIPTION="a script for managing file archives of various types"
HOMEPAGE="http://www.nongnu.org/atool/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl
	!app-text/adiff"

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
	dodoc AUTHORS ChangeLog NEWS README TODO
}
