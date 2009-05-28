# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/culmus/culmus-0.103.ebuild,v 1.5 2009/05/28 19:47:09 beandog Exp $

inherit font

DESCRIPTION="Hebrew Type1 fonts"
HOMEPAGE="http://culmus.sourceforge.net/"
SRC_URI="mirror://sourceforge/culmus/${P}.tar.gz
	mirror://sourceforge/culmus/david-type1-${PV}.tar.gz
	http://culmus.sourceforge.net/fancy/anka.tar.gz
	http://culmus.sourceforge.net/fancy/anka-otf.zip
	http://culmus.sourceforge.net/fancy/comix.tar.gz
	http://culmus.sourceforge.net/fancy/gan.tar.gz
	http://culmus.sourceforge.net/fancy/ozrad.tar.gz
	http://culmus.sourceforge.net/fancy/ktav-yad.tar.gz
	http://culmus.sourceforge.net/fancy/dorian.tar.gz
	http://culmus.sourceforge.net/fancy/gladia.tar.gz"

LICENSE="|| ( GPL-2 LICENSE-BITSTREAM )"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="afm pfa ttf"
FONT_CONF=( "65-culmus.conf" )
DOCS="CHANGES"

src_unpack() {
	unpack ${A}
	mv *.afm *.pfa "${S}"/
	cd "${S}"
	mv culmus.conf 65-culmus.conf
}

pkg_postinst() {
	elog "This font contains support for fontconfig, which may make"
	elog "it render more smoothly. To enable it, do:"
	elog "eselect fontconfig enable 65-culmus.conf"
}
