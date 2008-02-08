# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/pymacs/pymacs-0.23_beta5.ebuild,v 1.1 2008/02/08 14:01:22 ulm Exp $

inherit distutils elisp eutils versionator

MY_P=Pymacs-$(replace_version_separator 2 -)
DESCRIPTION="A tool that allows both-side communication beetween Python and Emacs-lisp"
HOMEPAGE="http://pymacs.progiciels-bpi.ca/"
SRC_URI="http://pymacs.progiciels-bpi.ca/archives/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd"
IUSE=""

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-fix-pytest-nonascii.patch
}

src_compile() {
	emake || die "emake failed"
	elisp-compile pymacs.el || die "elisp-compile failed"
}

src_install() {
	elisp_src_install
	distutils_src_install
	dodoc THANKS
}
