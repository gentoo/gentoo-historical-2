# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipdfm/dvipdfm-0.13.2d-r1.ebuild,v 1.13 2009/05/15 15:14:51 aballier Exp $

DESCRIPTION="DVI to PDF translator"
SRC_URI="http://gaspra.kettering.edu/dvipdfm/${P}.tar.gz"
HOMEPAGE="http://gaspra.kettering.edu/dvipdfm/"
LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

DEPEND="!>=app-text/tetex-2
	>=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	!app-text/ptex
	virtual/latex-base"

S="${WORKDIR}/${PN}"

src_install () {
	einstall || die "einstall failed!"

	# Install .map and .enc files to correct locations, bug #200956
	dodir /usr/share/texmf/fonts/map/dvipdfm/base

	for i in cmr.map psbase14.map lw35urw.map lw35urwa.map t1fonts.map; do
		mv "${D}usr/share/texmf/dvipdfm/config/${i}" "${D}usr/share/texmf/fonts/map/dvipdfm/base" || die "moving .map file failed"
	done

	dodir /usr/share/texmf/fonts/enc/dvipdfm

	mv "${D}usr/share/texmf/dvipdfm/base" "${D}usr/share/texmf/fonts/enc/dvipdfm/base" || die "moving .enc file failed"

	dodoc AUTHORS ChangeLog Credits NEWS OBTAINING README* TODO

	docinto doc
	dodoc doc/*

	docinto latex-support
	dodoc latex-support/*

	insinto /usr/share/texmf/tex/latex/dvipdfm/
	doins latex-support/dvipdfm.def
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		/usr/sbin/texmf-update
	fi
}
