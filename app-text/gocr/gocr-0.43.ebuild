# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gocr/gocr-0.43.ebuild,v 1.7 2007/06/29 12:34:01 angelos Exp $

inherit eutils

DESCRIPTION="An OCR (Optical Character Recognition) reader"
HOMEPAGE="http://jocr.sourceforge.net"
SRC_URI="mirror://sourceforge/jocr/${P}.tar.gz"
LICENSE="GPL-2"

IUSE="gtk doc tk"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc ~x86"

DEPEND=">=media-libs/netpbm-9.12
	doc? ( >=media-gfx/transfig-3.2 )
	gtk? ( =x11-libs/gtk+-1*
	       media-gfx/imagemagick )
	tk? ( dev-lang/tk )"

DOCS="AUTHORS BUGS CREDITS HISTORY RE* TODO"

src_unpack() {

	unpack ${A}

	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {

	local mymakes="src man"

	use gtk && mymakes="${mymakes} frontend"
	use doc && mymakes="${mymakes} doc examples"

	econf || die "econf failed"
	make ${mymakes} || die "make ${mymakes} failed"

}

src_install() {

	make DESTDIR="${D}" prefix="/usr"  exec_prefix="/usr" install || die "make install failed"
	# remove the tk frontend if tk is not selected
	use tk || rm "${D}"/usr/bin/gocr.tcl
	# install the gtk frontend
	use gtk && dobin "${S}"/frontend/gnome/src/gtk-ocr
	# and install the documentation and examples
	if use doc ; then
		DOCS="${DOCS} doc/gocr.html doc/examples.txt doc/unicode.txt"
		insinto /usr/share/doc/${P}/examples
		doins "${S}"/examples/*.{fig,tex,pcx}
	fi
	# and then install all the docs
	dodoc ${DOCS}

}
