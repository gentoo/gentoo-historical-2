# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lrzip/lrzip-0.23.ebuild,v 1.4 2009/09/27 12:09:46 maekke Exp $

DESCRIPTION="Long Range ZIP or Lzma RZIP"
HOMEPAGE="http://ck.kolivas.org/apps/lrzip/README"
SRC_URI="http://ck.kolivas.org/apps/lrzip/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="dev-libs/lzo
		app-arch/bzip2"
DEPEND="${DEPEND}
	x86? ( dev-lang/nasm )"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
