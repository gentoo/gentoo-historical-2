# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/hugin/hugin-0.5.ebuild,v 1.1 2005/12/18 07:27:21 halcy0n Exp $

inherit wxwidgets eutils

DESCRIPTION="GUI for the creation & processing of panoramic images"
HOMEPAGE="http://hugin.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2 SIFT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="unicode debug"

DEPEND=">=media-libs/libpano12-2.7.0.8
		>=dev-libs/boost-1.30.0
		>=x11-libs/wxGTK-2.6.0
		sys-libs/zlib
		media-libs/libpng
		media-libs/jpeg
		media-libs/tiff"

src_unpack() {
	unpack ${A}

	sed -i -e 's/autopanog\.exe/autopanog/' "${S}"/src/include/hugin/config_defaults.h
}

src_compile() {
	export WX_GTK_VER="2.6"

	if use unicode; then
		need-wxwidgets unicode || die "Emerge wxGTK with unicode in USE"
	else
		need-wxwidgets gtk2 || die "Emerge wxGTK with gtk2 in USE"
	fi

	myconf="`use_with unicode`
			`use_enable debug`"

	econf --with-wx-config="${WX_CONFIG}" ${myconf} || die "configure failed"
	emake || die "compiling failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS BUGS README TODO
}

pkg_postinst() {
	einfo "Please consider the helper apps autopano-sift and enblend."
	einfo "autopano-sift is used to automagically generate control"
	einfo "points and enblend is used to merge images smoothly."
}
