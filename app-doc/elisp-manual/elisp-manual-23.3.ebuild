# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/elisp-manual/elisp-manual-23.3.ebuild,v 1.2 2011/08/19 18:29:41 hwoarang Exp $

EAPI=4

inherit eutils

DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="http://www.gnu.org/software/emacs/manual/"
# taken from doc/lispref/ of emacs-23.3
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="FDL-1.3"
SLOT="23"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE=""

S="${WORKDIR}/lispref"

src_prepare() {
	epatch "${FILESDIR}/${P}-direntry.patch"
}

src_compile() {
	makeinfo elisp.texi || die "makeinfo failed"
}

src_install() {
	doinfo elisp23.info*
	dodoc ChangeLog README
}
