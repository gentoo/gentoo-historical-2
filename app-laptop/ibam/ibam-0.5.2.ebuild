# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/ibam/ibam-0.5.2.ebuild,v 1.1 2009/07/29 22:01:07 scarabeus Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Intelligent Battery Monitor"
HOMEPAGE="http://ibam.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gkrellm"

DEPEND="gkrellm? ( app-admin/gkrellm )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	sed -i \
		-e "s:^CFLAGS=-O3:CFLAGS=${CFLAGS}:" \
		-e "s:^CC=g++:CC=$(tc-getCXX):" \
		"${S}"/Makefile \
		|| die "Sed Makefile failed"
}

src_compile() {
	emake || die "Making ibam failed"
	if use gkrellm; then
		emake krell || die "Making krell failed"
	fi
}

src_install() {
	dobin ibam || die "dobin failed"
	dodoc CHANGES README REPORT || die "dodoc failed"

	if use gkrellm; then
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins ibam-krell.so || die "doins gkrellm plugin failed"
	fi
}

pkg_postinst() {
	elog
	elog "You will need to install sci-visualization/gnuplot if you wish to use"
	elog "the --plot argument to ibam."
	elog
}
