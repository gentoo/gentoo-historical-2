# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sexypsf/sexypsf-0.4.5.ebuild,v 1.2 2004/03/31 22:46:53 dholm Exp $

inherit eutils

DESCRIPTION="sexyPSF is an open-source PSF (Playstation music) file player"

MY_P="${PN}${PV//./}"
HOMEPAGE="http://xodnizel.net/${PN}/"
SRC_URI="http://xodnizel.net/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="xmms"
KEYWORDS="~x86 ~ppc"

DEPEND="sys-libs/zlib
	xmms? ( media-sound/xmms )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	cd ${S}/Linux

	# ppc and sparc are big-endian while all other keywords are
	# little-endian (as far as I know)
	use ppc64 || use ppc || use sparc && CPU="MSBFIRST" || CPU="LSBFIRST"

	emake CPU="${CPU}" || die

	if use xmms; then
		cd ${S}/xmms
		emake CPU="${CPU}" || die
	fi
}

src_install() {
	cd ${S}/Linux
	dobin sexypsf

	if use xmms; then
		cd ${S}/xmms
		exeinto `xmms-config --input-plugin-dir`
		doexe libsexypsf.so
	fi

	dodoc ${S}/Docs/*
}

pkg_postinst() {
	ewarn "The xmms plugin seems to be unstable.  It does not play minipsf files,"
	ewarn "but the command line works fine with them."
}
