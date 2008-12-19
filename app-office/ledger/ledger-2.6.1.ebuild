# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/ledger/ledger-2.6.1.ebuild,v 1.1 2008/12/19 21:52:36 loki_val Exp $

inherit eutils elisp-common

DESCRIPTION="A command-line accounting tool that provides double-entry accounting with a minimum of frills, and yet with a maximum of expressiveness and flexibility."
HOMEPAGE="http://www.newartisans.com/software.html"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="NewArtisans"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="emacs debug gnuplot ofx xml"

DEPEND="dev-libs/gmp
	dev-libs/libpcre
	ofx? ( >=dev-libs/libofx-0.9 )
	xml? ( dev-libs/expat )
	emacs? ( virtual/emacs )
	gnuplot? ( sci-visualization/gnuplot )"

SITEFILE=50${PN}-gentoo.el

src_compile() {

	econf \
		$(use_enable xml) \
		$(use_enable ofx) \
		$(use_enable debug) \
		$(use_with	 emacs lispdir "${D}${SITELISP}/${PN}") \
		|| die "Configure failed!"

	emake || die "Make failed!"
}

src_install() {

	dodoc sample.dat README NEWS

	## One script uses vi, the outher the Finance perl module
	## Did not add more use flags though
	insinto /usr/share/${P}
	doins scripts/entry scripts/getquote scripts/bal scripts/bal-huquq

	einstall || die "Installation failed!"

	# Remove timeclock since it is part of Emacs
	rm -f "${D}${SITELISP}/${PN}"/timeclock.*

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	if use gnuplot; then
		mv scripts/report ledger-report
		dobin ledger-report
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
