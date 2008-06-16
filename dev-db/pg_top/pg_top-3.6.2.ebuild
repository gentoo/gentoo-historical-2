# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pg_top/pg_top-3.6.2.ebuild,v 1.1 2008/06/16 10:51:27 cedk Exp $

DESCRIPTION="'top' for PostgreSQL"
HOMEPAGE="http://ptop.projects.postgresql.org/"
SRC_URI="http://pgfoundry.org/frs/download.php/1780/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

COMMON_DEPEND="virtual/postgresql-base"
DEPEND="$COMMON_DEPEND
	dev-util/pkgconfig"
RDEPEND="$COMMON_DEPEND"

src_compile() {
	econf $(use_enable debug)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc FAQ HISTORY README TODO Y2K
}
