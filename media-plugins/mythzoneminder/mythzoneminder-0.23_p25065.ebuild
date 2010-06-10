# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythzoneminder/mythzoneminder-0.23_p25065.ebuild,v 1.1 2010/06/10 14:54:54 cardoe Exp $

EAPI=2
MYTHTV_NODEPS="true"
inherit qt4 mythtv-plugins toolchain-funcs

DESCRIPTION="Allows for viewing of CCTV cameras through zoneminder"
IUSE="minimal"
KEYWORDS="~amd64"

DEPEND="minimal? ( dev-db/mysql
	www-misc/zoneminder )
	=media-tv/mythtv-${MY_PV}*"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:g++:$(tc-getCXX):" \
		"${S}"/mythzoneminder/mythzmserver/Makefile.standalone \
		|| die "Sed failed"
}

src_compile() {
	if use minimal; then
		cd "${S}/mythzoneminder/mythzmserver"
		emake CXX=$(tc-getCXX) -f Makefile.standalone || die "Emake failed"
	else
		mythtv-plugins_src_compile
	fi
}

src_install() {
	if use minimal; then
		dodoc README
		dobin "${S}/mythzoneminder/mythzmserver/mythzmserver" || die "Installing mythzmserver failed"
	else
		mythtv-plugins_src_install
	fi
}
