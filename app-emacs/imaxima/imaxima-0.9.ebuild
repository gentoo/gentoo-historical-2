# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/imaxima/imaxima-0.9.ebuild,v 1.4 2005/01/01 13:50:17 eradicator Exp $

inherit elisp

DESCRIPTION="Imaxima enables graphical output in Maxima sessions"
HOMEPAGE="http://purl.org/harder/imaxima.html"
SRC_URI="http://www.ifa.au.dk/~harder/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/emacs
	virtual/tetex
	virtual/ghostscript
	dev-tex/breqn
	>=sci-mathematics/maxima-0.9"

src_compile() {
	econf --prefix=/usr || die "econf failed"
	emake || die
}

src_install() {
	einstall || die
	elisp-site-file-install ${FILESDIR}/50imaxima-gentoo.el
	dodoc ChangeLog NEWS README
}
