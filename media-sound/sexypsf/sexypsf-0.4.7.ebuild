# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sexypsf/sexypsf-0.4.7.ebuild,v 1.1 2005/10/26 06:39:31 truedfx Exp $

inherit eutils

DESCRIPTION="sexyPSF is an open-source PSF1 (Playstation music) file player"
HOMEPAGE="http://projects.raphnet.net/#sexypsf"
SRC_URI="http://projects.raphnet.net/sexypsf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

#-amd64: 0.4.6: Segfault on playback using sexypsf.
#-sparc: 0.4.5: Couldn't load minispf
KEYWORDS="-amd64 ~ppc -sparc ~x86"
IUSE="xmms"

DEPEND="sys-libs/zlib
	xmms? ( media-sound/xmms )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-misc.patch
}

src_compile() {
	cd "${S}"/Linux

	# ppc and sparc are big-endian while all other keywords are
	# little-endian (as far as I know)
	use ppc64 || use ppc || use sparc && CPU="MSBFIRST" || CPU="LSBFIRST"

	emake CPU="${CPU}" || die "emake failed"

	if use xmms; then
		cd "${S}"
		# do make clean to force rebuild with -fPIC
		emake CPU="${CPU}" clean sexypsf || die "emake failed"
	fi
}

src_install() {
	dobin Linux/sexypsf

	if use xmms; then
		exeinto "$(xmms-config --input-plugin-dir)"
		doexe libsexypsf.so
	fi

	dodoc Docs/*
}
