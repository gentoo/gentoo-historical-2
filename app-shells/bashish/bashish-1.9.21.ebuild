# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/bashish/bashish-1.9.21.ebuild,v 1.5 2004/06/24 22:23:17 agriffis Exp $

DESCRIPTION="Text console theme engine"
HOMEPAGE="http://bashish.sourceforge.net/"
SRC_URI="mirror://sourceforge/bashish/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ppc alpha sparc"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp InstallBashish{,.orig}
	sed -e "s:read input:input=${D}/usr/share/bashish:" \
	 -e "s:read yesno:yesno=n:" \
		InstallBashish.orig > InstallBashish
}

src_install() {
	dodir /usr/share/bashish
	./InstallBashish || die
	dobin bashish
	dosed /usr/bin/bashish
	insinto /usr/share/bashish/modules/sh/conf
	doins ${FILESDIR}/bashish.conf
}
