# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mew/mew-3.3.ebuild,v 1.7 2005/01/01 13:53:58 eradicator Exp $

inherit elisp

IUSE="ssl"

DESCRIPTION="great MIME mail reader for Emacs/XEmacs"
HOMEPAGE="http://www.mew.org/"
SRC_URI="ftp://ftp.mew.org/pub/Mew/release/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 alpha ppc sparc"

DEPEND="virtual/emacs"
RDEPEND="${DEPEND}
	ssl? ( =net-misc/stunnel-3* )"

SITEFILE=50mew-gentoo.el

src_compile() {
	emake || die
}

src_install() {
	einstall prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		elispdir=${D}/${SITELISP}/${PN} \
		etcdir=${D}/usr/share/${PN} \
		mandir=${D}/usr/share/man/man1 || die

	elisp-site-file-install ${FILESDIR}/3.x/${SITEFILE}

	dodoc 00*

	insinto /etc/skel
	newins mew.dot.mew .mew.el
	newins mew.dot.emacs .emacs.mew
}

pkg_postinst() {
	elisp-site-regen

	einfo "Refer to the Info documentation on Mew for how to get started."
	einfo ""
	einfo "If you use mew-2.* until now, you should rewrite \${HOME}/.mew.el"
	einfo ""
}

pkg_postrm() {
	elisp-site-regen
}
