# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/ledger/ledger-2.6.2.ebuild,v 1.3 2010/02/20 08:11:11 abcd Exp $

EAPI=3

inherit eutils elisp-common

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://wiki.github.com/jwiegley/ledger"

SRC_URI="http://cloud.github.com/downloads/jwiegley/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"
SLOT="0"
IUSE="emacs debug gnuplot ofx xml"

DEPEND="dev-libs/gmp
	dev-libs/libpcre
	ofx? ( >=dev-libs/libofx-0.9 )
	xml? ( dev-libs/expat )
	emacs? ( virtual/emacs )
	gnuplot? ( sci-visualization/gnuplot )"
RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.1-glibc-2.10.patch
}

src_configure() {
	econf \
		$(use_enable xml) \
		$(use_enable ofx) \
		$(use_enable debug) \
		$(use_with emacs lispdir "${ED}${SITELISP}/${PN}")
}

src_install() {

	dodoc sample.dat README NEWS

	## One script uses vi, the outher the Finance perl module
	## Did not add more use flags though
	insinto /usr/share/${P}
	doins scripts/entry scripts/getquote scripts/bal scripts/bal-huquq || die

	einstall || die "Installation failed!"

	# Remove timeclock since it is part of Emacs
	rm -f "${ED}${SITELISP}/${PN}"/timeclock.*

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	if use gnuplot; then
		mv scripts/report ledger-report
		dobin ledger-report || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
