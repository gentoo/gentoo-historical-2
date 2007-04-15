# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lrzip/lrzip-0.18.ebuild,v 1.1 2007/04/15 09:49:46 lu_zero Exp $

DESCRIPTION="Long Range ZIP or Lzma RZIP"
HOMEPAGE="http://ck.kolivas.org/apps/lrzip/README"
SRC_URI="http://ck.kolivas.org/apps/lrzip/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"
IUSE=""

DEPEND="dev-libs/lzo
		app-arch/bzip2"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}

