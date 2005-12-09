# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/loki_patch/loki_patch-20051209.ebuild,v 1.1 2005/12/09 20:18:38 wolf31o2 Exp $

inherit eutils

DESCRIPTION="Loki Software binary patch tool"
HOMEPAGE="http://www.icculus.org/loki_setup/"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-util/xdelta
	dev-libs/libxml"
RDEPEND="games-util/loki_setupdb"

src_compile() {
	./autogen.sh || die "autogen failed."
	econf \
		--with-setupdb=/usr/share/loki_setupdb \
		|| die "econf failed."
	sed -i \
		-e 's/\.\.\/loki_setupdb/\/usr\/share\/loki_setupdb/' \
		-e 's/-I$(SETUPDB)/-I$(SETUPDB)\/include/' \
		Makefile
	emake || die "emake failed"
}

src_install() {
	dobin loki_patch make_patch || die "doexe failed"
	dodoc CHANGES NOTES README TODO
}
