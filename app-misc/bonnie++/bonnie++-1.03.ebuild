# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bonnie++/bonnie++-1.03.ebuild,v 1.1 2003/01/05 06:25:51 george Exp $

DESCRIPTION="Hard drive bottleneck testing benchmark suite."
SRC_URI="http://www.coker.com.au/bonnie++/${P}.tgz"
HOMEPAGE="http://www.coker.com.au/bonnie++/"

SLOT="0"
LICENSE="GPL-2"
# I think this should work on other than x86 platforms (by sandymac)
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
IUSE=""
DEPEND="virtual/glibc"

src_compile() {
	local myconf=""
	[ "$DEBUG" == "true" ] && myconf="--with-debug --disable-stripping"

	econf ${myconf}
	emake || die "emake failed"
	emake zcav || die "emake zcav failed" # see #9073
}

src_install() {
	dosbin bonnie++ zcav
	dobin bon_csv2html bon_csv2txt
	doman bon_csv2html.1 bon_csv2txt.1 bonnie++.8 zcav.8
	dohtml readme.html
	dodoc changelog.txt copyright.txt credits.txt
}
