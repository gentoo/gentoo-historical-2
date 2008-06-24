# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/easypg/easypg-0.0.16.ebuild,v 1.2 2008/06/24 06:24:01 opfer Exp $

inherit elisp versionator

MY_PN=epg

DESCRIPTION="GnuPG interface for Emacs"
HOMEPAGE="http://www.easypg.org/"
SRC_URI="mirror://sourceforge.jp/epg/29289/${MY_PN}-${PV}.tar.gz
	gnus? ( mirror://sourceforge.jp/epg/25608/pgg-${MY_PN}.el )"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnus"

DEPEND="app-crypt/gnupg"
RDEPEND="${DEPEND}
	gnus? ( virtual/gnus )"

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A}
	use gnus && cp "${DISTDIR}/pgg-epg.el" "${S}"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	elisp-make-autoload-file \
		|| die "elisp-make-autoload-file failed"

	if use gnus && version_is_at_least 22 "$(elisp-emacs-version)"; then
		# pgg-epg requires pgg, it will not compile with Emacs 21
		# it also requires epa, so we must use elisp-comp here
		elisp-comp pgg-epg.el || die "elisp-comp failed"
	fi
}

src_install() {
	einstall || die "einstall failed"

	elisp-install ${MY_PN} ${PN}-autoloads.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" ${MY_PN}
	if use gnus; then
		elisp-install ${MY_PN} pgg-epg.el*
	fi
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}

pkg_postinst() {
	elisp-site-regen
	elog "See the epa info page for more information"
	if use gnus; then
		elog "To use, add (setq pgg-scheme 'epg) to your ~/.gnus"
	fi
}
