# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/anthy/anthy-7900.ebuild,v 1.2 2006/09/06 12:28:51 hattya Exp $

inherit autotools elisp-common eutils

IUSE="emacs ucs4"

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/20887/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
SLOT="0"

DEPEND="!app-i18n/anthy-ss
	emacs? ( virtual/emacs )"

src_unpack() {

	unpack ${A}
	cd "${S}"

	local cannadicdir=/var/lib/canna/dic/canna

	if has_version 'app-dicts/canna-2ch'; then
		einfo "Adding nichan.ctd to anthy.dic."
		sed -i /placename/a"read ${cannadicdir}/nichan.ctd" \
			mkworddic/dict.args.in
	fi

	epatch "${FILESDIR}"/${P}-asneeded.diff

	eautomake
	elibtoolize

}

src_compile() {

	local myconf

	use emacs || myconf="EMACS=no"
	use ucs4 && myconf="${myconf} --enable-ucs4"

	econf ${myconf} || die
	emake -j1 || die

}

src_install() {

	emake DESTDIR="${D}" install || die

	use emacs && elisp-site-file-install "${FILESDIR}"/50anthy-gentoo.el

	dodoc AUTHORS DIARY NEWS README ChangeLog

	docinto doc
	rm doc/Makefile*
	dodoc doc/*

}

pkg_postinst() {

	use emacs && elisp-site-regen

}

pkg_postrm() {

	has_version virtual/emacs && elisp-site-regen

}
