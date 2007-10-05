# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtypist/gtypist-2.7-r1.ebuild,v 1.1 2007/10/05 20:32:55 ulm Exp $

inherit eutils elisp-common

DESCRIPTION="Universal typing tutor"
HOMEPAGE="http://www.gnu.org/software/gtypist/"
SRC_URI="mirror://gnu/gtypist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="nls emacs xemacs"

DEPEND=">=sys-libs/ncurses-5.2
	emacs? ( virtual/emacs )
	xemacs? ( !emacs? ( virtual/xemacs app-xemacs/fsf-compat ) )"

RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-xemacs-compat.patch
}

src_compile() {
	local lispdir=""
	if use emacs; then
		lispdir="${SITELISP}/${PN}"
		einfo "Configuring to build with GNU Emacs support"
	elif use xemacs; then
		lispdir="/usr/lib/xemacs/site-packages/lisp/${PN}"
		einfo "Configuring to build with XEmacs support"
	fi

	econf $(use_enable nls) \
		EMACS=$(usev emacs || usev xemacs || echo no) \
		--with-lispdir="${lispdir}" \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
