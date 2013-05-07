# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/premake/premake-4.3-r1.ebuild,v 1.2 2013/05/07 19:32:35 ago Exp $

EAPI=5

inherit versionator

DESCRIPTION="A makefile generation tool"
HOMEPAGE="http://industriousone.com/premake"
SRC_URI="mirror://sourceforge/premake/${P}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/archless.patch"
}

src_compile() {
	emake -C build/gmake.unix/
}

src_install() {
	dobin bin/release/premake4
}
