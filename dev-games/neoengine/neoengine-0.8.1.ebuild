# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/neoengine/neoengine-0.8.1.ebuild,v 1.3 2004/06/24 22:13:21 agriffis Exp $

inherit eutils

S="${WORKDIR}/${P}/neoengine"
DESCRIPTION="An open source, platform independent, 3D game engine written in C++"
SRC_URI="mirror://sourceforge/neoengine/${P}.tar.bz2"
HOMEPAGE="http://www.neoengine.org/"
LICENSE="MPL-1.1"
DEPEND="virtual/opengl
	media-libs/alsa-lib
	doc? ( app-doc/doxygen )"
KEYWORDS="~ppc ~x86"
SLOT="0"
IUSE="doc"

src_compile() {
	econf || die "./configure failed"
	emake || die "Compilation failed"

	if use doc; then
		for i in "*.doxygen"; do
			doxygen ${i};
		done
	fi
}

src_install () {
	einstall || die "Installation failed"

	dodoc AUTHORS ChangeLog COPYING INSTALL README TODO

	if use doc; then
		mkdir -p ${D}/usr/share/doc/${P}
		for i in "*-api"; do
			cp -r ${i} ${D}/usr/share/doc/${P};
		done
	fi
}
