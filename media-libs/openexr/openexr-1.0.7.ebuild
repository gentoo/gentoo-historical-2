# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openexr/openexr-1.0.7.ebuild,v 1.9 2005/09/10 13:04:08 flameeyes Exp $

inherit eutils

MY_P=OpenEXR-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="ILM's HDR image file format libraries"
SRC_URI="http://www.openexr.org/downloads/${MY_P}.tar.gz"
HOMEPAGE="http://www.openexr.com"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="x11-libs/fltk"

src_unpack() {
	unpack ${A}

	#Lets NVSDK test work correctly & html docs install to the correct directory
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	econf \
		--disable-fltktest \
		--enable-imfexamples \
		|| die "configure failed"

	emake \
	CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
	AM_CFLAGS="${CFLAGS}" AM_CXXFLAGS="${CXXFLAGS}" \
	|| die "make failed"
}

src_install () {
	einstall || die "install failed"

	dodoc AUTHORS README ChangeLog LICENSE NEWS
	dohtml -r ${S}/doc/*
}
