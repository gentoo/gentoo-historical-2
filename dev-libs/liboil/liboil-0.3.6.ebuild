# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liboil/liboil-0.3.6.ebuild,v 1.6 2006/01/22 19:07:11 dang Exp $

inherit eutils
DESCRIPTION="Liboil is a library of simple functions that are optimized for various CPUs."
HOMEPAGE="http://www.schleef.org/liboil/"
SRC_URI="http://www.schleef.org/${PN}/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0.3"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86"
IUSE=""
#RESTRICT="nostrip"
DEPEND="=dev-libs/glib-2*"
#RDEPEND=""
#S=${WORKDIR}/${P}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
