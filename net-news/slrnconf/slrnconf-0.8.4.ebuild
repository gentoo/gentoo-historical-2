# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/slrnconf/slrnconf-0.8.4.ebuild,v 1.1 2004/07/04 22:01:01 swegener Exp $

DESCRIPTION="slrnconf is a graphical configuation utility for the newsreader slrn"
HOMEPAGE="http://home.arcor.de/kaffeetisch/slrnconf.html"
SRC_URI="http://home.arcor.de/kaffeetisch/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-news/slrn
	dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/Parse-RecDescent
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	sed -i -e 's/^install: all$/install:/' ${S}/Makefile
}

src_compile() {
	make PREFIX=/usr || die "make failed"
}

src_install() {
	make PREFIX=${D}/usr install || die "make install failed"
}
