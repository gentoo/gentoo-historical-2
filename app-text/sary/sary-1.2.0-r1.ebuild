# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sary/sary-1.2.0-r1.ebuild,v 1.6 2012/03/07 15:50:11 naota Exp $

EAPI=4

DESCRIPTION="Sary: suffix array library and tools"
HOMEPAGE="http://sary.sourceforge.net/"
SRC_URI="http://sary.sourceforge.net/${P}.tar.gz"
IUSE="static-libs"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
RESTRICT="test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {

	emake DESTDIR="${D}" \
		docsdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		install || die

	dodoc AUTHORS ChangeLog NEWS README TODO

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete
	fi

}
