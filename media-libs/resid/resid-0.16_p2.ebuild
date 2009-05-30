# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/resid/resid-0.16_p2.ebuild,v 1.2 2009/05/30 15:59:44 ssuominen Exp $

EAPI=2
inherit autotools versionator

MY_MAJ=$(get_version_component_range 1-2)

DESCRIPTION="C++ library to emulate the C64 SID chip"
HOMEPAGE="http://sidplay2.sourceforge.net"
SRC_URI="mirror://sourceforge/sidplay2/${P/_p/-p}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${PN}-${MY_MAJ}

src_prepare() {
	# This is required, otherwise the shared libraries get installed as
	# libresid.0.0.0 instead of libresid.so.0.0.0.
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-shared \
		--enable-static \
		--enable-resid-install
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO VC_CC_SUPPORT.txt
}
