# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/edje/edje-1.7.0.ebuild,v 1.1 2012/09/08 11:12:38 tommy Exp $

EAPI=1

inherit enlightenment

DESCRIPTION="graphical layout and animation library"
HOMEPAGE="http://www.enlightenment.org/pages/edje.html"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="debug +cache static-libs vim-syntax"

DEPEND="dev-lang/lua
	>=dev-libs/eet-1.7.0
	>=dev-libs/eina-1.7.0
	>=dev-libs/embryo-1.7.0
	>=media-libs/evas-1.7.0
	>=dev-libs/ecore-1.7.0"
RDEPEND=${DEPEND}

src_compile() {
	export MY_ECONF="
		$(use_enable cache edje-program-cache)
		$(use_enable cache edje-calc-cache)
		$(use_enable !debug amalgamation)
		$(use_with vim-syntax vim /usr/share/vim)
	"
	enlightenment_src_compile
}

src_install() {
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins data/edc.vim || die
	fi
	dodoc utils/{gimp-edje-export.py,inkscape2edc} || die
	enlightenment_src_install
}
