# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/anthy-ss/anthy-ss-4519.ebuild,v 1.1 2003/09/25 18:51:01 usata Exp $

inherit elisp-common

IUSE="emacs"

MY_P="${P/-ss/}"

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/anthy/6003/${MY_P}.tar.gz"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

S="${WORKDIR}/${MY_P}"

DEPEND="virtual/glibc
	emacs? ( virtual/emacs )
	!app-i18n/anthy"

SITEFILE="50anthy-gentoo.el"

src_compile() {

	local myconf cannadicdir
	cannadicdir=/var/lib/canna/dic/canna

	use emacs \
		|| myconf="${myconf} EMACS=no"

	if has_version 'app-dicts/canna-zipcode' ; then
		einfo "Adding zipcode.t and jigyosyo.t to anthy.dic."
		cp ${cannadicdir}/{zipcode,jigyosyo}.t mkanthydic
		sed -i -e "/^EXTRA_DICS/s|$| zipcode.t jigyosyo.t|" \
			mkanthydic/Makefile.{in,am}
	fi
	if has_version 'app-dicts/canna-2ch' ; then
		einfo "Adding nichan.ctd to anthy.dic."
		cp ${cannadicdir}/nichan.ctd mkanthydic/2ch.t
		sed -i -e "/^EXTRA_DICS/s|$| 2ch.t|" \
			mkanthydic/Makefile.{in,am}
	fi

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	use emacs && elisp-site-file-install ${FILESDIR}/${SITEFILE}

	dodoc AUTHORS ChangeLog DIARY INSTALL NEWS README \
		doc/[A-Z0-9][A-Z0-9]* doc/protocol.txt
}

pkg_postinst() {

	use emacs && elisp-site-regen
}

pkg_postrm() {

	use emacs && elisp-site-regen
}
