# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/localizer/localizer-0.3.3.ebuild,v 1.5 2005/01/01 21:59:29 kingtaco Exp $

DESCRIPTION="Localisation library for lighttpd"
HOMEPAGE="http://www.incremental.de/products/localizer/"
SRC_URI="http://www.incremental.de/products/localizer/download/${P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""
DEPEND=""
#RDEPEND=""

src_compile() {
	local my_conf

	my_conf="$my_conf --enable-static --enable-shared"
	econf $my_conf || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
