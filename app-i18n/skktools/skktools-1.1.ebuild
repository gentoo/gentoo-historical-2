# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skktools/skktools-1.1.ebuild,v 1.6 2005/01/01 14:42:03 eradicator Exp $

inherit elisp-common

DESCRIPTION="SKK utilities to manage dictionaries"
HOMEPAGE="http://openlab.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="ruby emacs"

DEPEND="virtual/libc
	>=dev-libs/glib-2"

src_install() {
	einstall || die

	use ruby && dobin saihenkan.rb
	use emacs && elisp-site-file-install skk-xml.el

	insinto /usr/share/skk
	doins unannotation.awk

	dodoc ChangeLog README READMEs/*
}
