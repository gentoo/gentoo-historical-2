# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/slime/slime-2.0_p20070816-r3.ebuild,v 1.4 2008/08/01 16:07:11 ulm Exp $

inherit common-lisp elisp eutils

DESCRIPTION="SLIME, the Superior Lisp Interaction Mode (Extended)"
HOMEPAGE="http://common-lisp.net/project/slime/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2 xref.lisp"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

RDEPEND="virtual/commonlisp dev-lisp/cl-asdf"
DEPEND="${RDEPEND}
	doc? ( virtual/texi2dvi )"

CLPACKAGE=swank
SITEFILE=70${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}/changelog-date.patch
	epatch "${FILESDIR}"/${PV}/save-restriction-if-possible.patch

	# extract date of last update from ChangeLog, bug 233270
	SLIME_CHANGELOG_DATE=$(awk '/^[-0-9]+ / { print $1; exit; }' ChangeLog)
	[ -n "${SLIME_CHANGELOG_DATE}" ] || die "cannot determine ChangeLog date"

	sed -i "/(defvar \*swank-wire-protocol-version\*/s:nil:\"${SLIME_CHANGELOG_DATE}\":" swank.lisp \
		|| die "sed swank.lisp failed"
	sed -i "s:@SLIME-CHANGELOG-DATE@:${SLIME_CHANGELOG_DATE}:" slime.el \
		|| die "sed slime.el failed"
}

src_compile() {
	elisp-comp *.el || die "elisp-comp failed"
	emake -j1 -C doc slime.info || die "emake slime.info failed"
	if use doc; then
		VARTEXFONTS="${T}"/fonts \
			emake -j1 -C doc slime.{ps,pdf} || die "emake doc failed"
	fi
}

src_install() {
	elisp-install ${PN} *.el{,c} "${FILESDIR}"/swank-loader.lisp \
		|| die "Cannot install SLIME core"
	elisp-site-file-install "${FILESDIR}"/${PV}/${SITEFILE} \
		|| die "elisp-site-file-install failed"
	insinto "${CLSOURCEROOT%/}"/swank
	doins *.lisp "${FILESDIR}"/${PV}/swank.asd
	dodir "${CLSYSTEMROOT}"
	dosym "${CLSOURCEROOT%/}"/swank/swank.asd "${CLSYSTEMROOT}"
	dosym "${SITELISP}"/${PN}/swank-version.el "${CLSOURCEROOT%/}"/swank

	dodoc README* ChangeLog HACKING NEWS PROBLEMS || die "dodoc failed"
	doinfo doc/slime.info
	if use doc; then
		dodoc doc/slime.{ps,pdf} || die "dodoc failed"
	fi
}
