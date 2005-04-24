# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/DirectFB-extra/DirectFB-extra-0.9.16.ebuild,v 1.12 2005/04/24 03:07:38 hansmi Exp $

inherit eutils

DESCRIPTION="Extra image/video/font providers and graphics/input drivers for DirectFB"
HOMEPAGE="http://www.directfb.org/"
SRC_URI="http://directfb.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc -sparc"
IUSE="quicktime flash imlib"

DEPEND=">=dev-libs/DirectFB-${PV}*
	quicktime? ( virtual/quicktime )
	flash? ( media-libs/libflash )
	imlib? ( media-libs/imlib2 )"
#	avi? ( media-video/avifile )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-newdirectfb.patch"
}

src_compile() {
#		`use_enable avi avifile` \
	econf \
		$(use_enable flash) \
		--disable-avifile \
		 || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
