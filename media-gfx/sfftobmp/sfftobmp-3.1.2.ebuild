# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sfftobmp/sfftobmp-3.1.2.ebuild,v 1.2 2010/01/25 14:45:18 ssuominen Exp $

EAPI=2
inherit autotools eutils

MY_P=${PN}${PV//./_}

DESCRIPTION="sff to bmp converter"
HOMEPAGE="http://sfftools.sourceforge.net/"
SRC_URI="mirror://sourceforge/sfftools/${MY_P}_src.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	media-libs/tiff
	media-libs/jpeg:0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.1-gcc44-and-boost-1_37.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/{changes,credits,readme}
}
