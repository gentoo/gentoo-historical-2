# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/qmatplot/qmatplot-0.4.2.ebuild,v 1.1 2003/11/12 12:01:02 phosphan Exp $



inherit kde-functions
inherit eutils
need-qt 3

DESCRIPTION="gnuplot-like tool for plotting data sets in either two or three dimensions"
HOMEPAGE="http://qmatplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

DEPEND=">=app-sci/octave-2.1
	>=app-sci/scilab-2.6"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog
}
