# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/antiword/antiword-0.36.1.ebuild,v 1.1 2004/12/26 18:00:42 seemant Exp $

IUSE="kde"
DESCRIPTION="free MS Word reader"
SRC_URI="http://www.winfield.demon.nl/linux/${P}.tar.gz"
HOMEPAGE="http://www.winfield.demon.nl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 amd64 ppc sparc alpha ~hppa ppc64"

DEPEND="virtual/ghostscript"

src_unpack() {
	unpack ${A}
	cd ${S}

}

src_compile() {
	emake || die
}

src_install() {
	dobin antiword
	use kde && dobin kantiword

	insinto /usr/share/${PN}
	doins Resources/*

	insinto /usr/share/${PN}/examples
	doins Docs/testdoc.doc Docs/antiword.php

	cd Docs
	doman antiword.1
	dodoc COPYING ChangeLog Exmh Emacs FAQ History Netscape \
	QandA ReadMe Mozilla Mutt
}
