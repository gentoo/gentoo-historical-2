# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/colordiff/colordiff-1.0.4.ebuild,v 1.5 2004/05/10 11:44:04 fmccor Exp $

DESCRIPTION="Colorizes output of diff"
HOMEPAGE="http://colordiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/colordiff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 alpha sparc"

DEPEND="sys-apps/diffutils"

src_install() {
	newbin colordiff.pl colordiff
	insinto /etc
	doins colordiffrc colordiffrc-lightbg
	fowners root:root /etc/colordiffrc /etc/colordiffrc-lightbg
	fperms 644 /etc/colordiffrc /etc/colordiffrc-lightbg
	dodoc BUGS CHANGES COPYING README TODO
}
