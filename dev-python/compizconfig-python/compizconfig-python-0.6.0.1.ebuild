# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/compizconfig-python/compizconfig-python-0.6.0.1.ebuild,v 1.4 2007/10/25 14:14:24 tester Exp $

DESCRIPTION="libcompizconfig python bindings"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libcompizconfig
	>=dev-libs/glib-2.6
	dev-python/pyrex"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
