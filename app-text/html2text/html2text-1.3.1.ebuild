# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/html2text/html2text-1.3.1.ebuild,v 1.14 2006/03/16 14:35:12 ehmsen Exp $

inherit eutils

DESCRIPTION="A HTML to text converter"
HOMEPAGE="http://userpage.fu-berlin.de/~mbayer/tools/html2text.html"
SRC_URI="http://userpage.fu-berlin.de/~mbayer/tools/historic/${P}.tar.gz
		mirror://gentoo/${PN}-gcc3.3.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	# apply a patch for g++ 3.3, provided by the html2text
	# people (see homepage) <obz@gentoo.org>
	if has_version ">=sys-devel/gcc-3.3*"; then
		epatch ${DISTDIR}/${PN}-gcc3.3.patch
	fi
}

src_compile() {
	./configure || die
	emake || die
}

src_install() {
	dobin html2text
	doman html2text.1.gz
	doman html2textrc.5.gz
	dodoc CHANGES CREDITS KNOWN_BUGS README TODO
}
