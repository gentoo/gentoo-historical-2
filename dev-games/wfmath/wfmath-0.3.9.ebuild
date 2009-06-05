# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/wfmath/wfmath-0.3.9.ebuild,v 1.1 2009/06/05 12:49:29 tupone Exp $
EAPI=2

DESCRIPTION="Worldforge math library"
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/wfmath"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	media-libs/atlas-c++"

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd doc && emake doc || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	if use doc; then
		dohtml doc/html/*
	fi
}
