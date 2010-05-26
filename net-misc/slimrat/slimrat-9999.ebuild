# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/slimrat/slimrat-9999.ebuild,v 1.1 2010/05/26 07:53:07 scarabeus Exp $

EAPI=2

inherit eutils confutils subversion

DESCRIPTION="Linux Rapidshare downloader"
HOMEPAGE="http://code.google.com/p/slimrat/"
SRC_URI=""
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="X"

DEPEND="
	>=dev-lang/perl-5.10.1[ithreads]
	>=dev-perl/WWW-Mechanize-1.52
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor
	X? (
		dev-perl/gtk2-gladexml
		dev-perl/Spiffy
		x11-misc/xclip
	)
"
# aview: displaying captcha
RDEPEND="${DEPEND}
	media-gfx/aview
	X? ( x11-terms/xterm )
"

src_prepare() {
	esvn_clean
}

src_install() {
	# install binaries

	exeinto "/usr/share/${PN}"

	doexe "src/${PN}" || die "doexe failed"
	dosym "/usr/share/${PN}/${PN}" "${ROOT}usr/bin/${PN}"

	if use X; then
		doexe "src/${PN}-gui" || die "doexe failed"
		dosym "/usr/share/${PN}/${PN}-gui" "/usr/bin/${PN}-gui"
	fi

	# install data
	insinto /etc
	newins "${S}/slimrat.conf" slimrat.conf

	insinto "/usr/share/${PN}"
	doins -r "src/"*.pm "src/Clipboard" "src/plugins/" "src/${PN}.glade" || die "doins failed"
}
