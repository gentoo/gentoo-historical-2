# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libieee1284/libieee1284-0.2.11.ebuild,v 1.2 2009/05/31 10:04:27 maekke Exp $

DESCRIPTION="Library to query devices using IEEE1284"
HOMEPAGE="http://cyberelk.net/tim/libieee1284/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-sgml-utils
		>=app-text/docbook-sgml-dtd-4.1
		app-text/docbook-dsssl-stylesheets
		dev-perl/XML-RegExp
	)"

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README* TODO doc/interface*
}
