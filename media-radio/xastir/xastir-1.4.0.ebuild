# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/xastir/xastir-1.4.0.ebuild,v 1.1 2004/09/19 19:42:34 rphillips Exp $

DESCRIPTION="XASTIR"
HOMEPAGE="http://xastir.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ax25 festival shape imagemagick curl"

DEPEND="virtual/libc
	x11-libs/openmotif
	ax25? ( dev-libs/libax25
		media-radio/ax25-apps
		media-radio/ax25-tools )
	festival? ( app-accessibility/festival )
	shape? ( dev-libs/shapelib
		dev-libs/libpcre )
	imagemagick? ( media-gfx/imagemagick )
	curl? ( net-misc/curl )"

src_install() {
	make DESTDIR=${D} install || die
	mkdir -p ${D}/usr/local
	dosym ../xastir usr/local/xastir
}
