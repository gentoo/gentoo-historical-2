# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sary/sary-1.1.0.ebuild,v 1.4 2005/02/10 08:50:33 usata Exp $

IUSE=""

DESCRIPTION="Sary: suffix array library and tools"
HOMEPAGE="http://sary.namazu.org/"
SRC_URI="http://prime.sourceforge.jp/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="x86 alpha ppc ~ppc64"
SLOT="0"

DEPEND=">=dev-libs/glib-2"

src_install() {

	make DESTDIR=${D} \
		docsdir=/usr/share/doc/${PF}/html \
		install || die

	dodoc [A-Z][A-Z]* ChangeLog

}
