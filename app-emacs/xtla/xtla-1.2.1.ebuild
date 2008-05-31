# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/xtla/xtla-1.2.1.ebuild,v 1.3 2008/05/31 07:58:57 ulm Exp $

inherit elisp

DESCRIPTION="The Emacs interface to GNU TLA"
HOMEPAGE="http://wiki.gnuarch.org/moin.cgi/xtla
	https://gna.org/projects/xtla-el
	http://www.gnu.org/software/gnu-arch/"
SRC_URI="http://download.gna.org/xtla-el/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-util/tla"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_compile() {
	econf --with-emacs=/usr/bin/emacs --with-lispdir=${SITELISP}/${PN} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	elisp-install ${PN} lisp/*.{el,elc} || die "elisp-install failed"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
		|| die "elisp-site-file-install failed"
	doinfo texinfo/xtla.info
	dodoc ChangeLog INSTALL docs/*
}
