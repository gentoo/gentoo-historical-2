# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libdexter/libdexter-0.1.4.ebuild,v 1.3 2008/02/14 05:38:01 mr_bones_ Exp $

inherit flag-o-matic

DESCRIPTION="Libdexter is a plugin-based, distributed sampling library"
HOMEPAGE="http://www.libdexter.org"
SRC_URI="mirror://sourceforge/libdexter/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15
	>=dev-libs/glib-2.10
	doc? (
		>=dev-util/gtk-doc-1.6
		~app-text/docbook-xml-dtd-4.1.2
	)"

src_compile() {
	econf \
		$(use_enable doc gtk-doc) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README NEWS AUTHORS TODO
}
