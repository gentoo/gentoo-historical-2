# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/anthy/anthy-5500.ebuild,v 1.8 2004/11/23 10:09:25 hattya Exp $

inherit elisp-common

IUSE="emacs"

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/10139/${P}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha amd64 sparc ~ppc-macos"
SLOT="0"

DEPEND="emacs? ( virtual/emacs )
	!app-i18n/anthy-ss"

# Anthy can not compile with sandbox since version 5209.
# It always causes SEGV at making mkanthydic.
SANDBOX_DISABLED="1"

src_compile() {

	local myconf
	local cannadicdir=/var/lib/canna/dic/canna

	use emacs || myconf="EMACS=no"

	if has_version 'app-dicts/canna-zipcode'; then
		einfo "Adding zipcode.t and jigyosyo.t to anthy.dic."
		cp ${cannadicdir}/{zipcode,jigyosyo}.t mkanthydic
		sed -i -e "/^EXTRA_DICS/s|$| zipcode.t jigyosyo.t|" \
			mkanthydic/Makefile.{in,am}
	fi

	if has_version 'app-dicts/canna-2ch'; then
		einfo "Adding nichan.ctd to anthy.dic."
		cp ${cannadicdir}/nichan.ctd mkanthydic/2ch.t
		sed -i -e "/^EXTRA_DICS/s|$| 2ch.t|" \
			mkanthydic/Makefile.{in,am}
	fi

	econf ${myconf} || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die

	use emacs && elisp-site-file-install ${FILESDIR}/50anthy-gentoo.el

	dodoc [A-Z][A-Z]* ChangeLog doc/[A-Z0-9][A-Z0-9]* doc/protocol.txt

}

pkg_postinst() {

	use emacs && elisp-site-regen

}

pkg_postrm() {

	has_version virtual/emacs && elisp-site-regen

}
