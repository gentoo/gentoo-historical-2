# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/riece/riece-1.0.4.ebuild,v 1.3 2005/01/01 13:59:14 eradicator Exp $

inherit elisp

IUSE=""

DESCRIPTION="Riece is a redesign of Liece IRC client"
HOMEPAGE="http://wiliki.designflaw.org/riece.cgi"
SRC_URI="http://wiliki.designflaw.org/riece/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ppc ~ppc64 ~amd64 ppc-macos"

DEPEND="virtual/emacs"

SITEFILE=50riece-gentoo.el

src_compile() {

	econf --with-lispdir=${SITELISP} || die "econf failed"
	emake || die "emake failed"
}

src_install () {

	einstall lispdir=${D}/${SITELISP} || die "einstall failed"
	elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
