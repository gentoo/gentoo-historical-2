# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/tpp/tpp-1.1.1.ebuild,v 1.1 2005/03/02 12:39:08 citizen428 Exp $

inherit eutils ruby

DESCRIPTION="An ncurses-based presentation tool."
HOMEPAGE="http://synflood.at/tpp.html"
SRC_URI="http://synflood.at/tpp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="figlet"

USE_RUBY="ruby18"

RDEPEND="virtual/ruby
	dev-ruby/ncurses-ruby
	figlet? ( app-misc/figlet )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-Makefile.patch
}

src_compile() {
	true
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
