# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubymail/rubymail-0.16.ebuild,v 1.5 2004/06/25 02:01:40 agriffis Exp $

inherit ruby

DESCRIPTION="A mail handling library for Ruby"
HOMEPAGE="http://www.lickey.com/rubymail/"
SRC_URI="http://www.lickey.com/rubymail/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~hppa ~mips ~sparc ~x86 ~ppc"
USE_RUBY="any"
IUSE=""
DEPEND="virtual/ruby"

src_compile() {
	ruby install.rb config --prefix=/usr || die
	ruby install.rb setup || die
}

src_install() {
	ruby install.rb config --prefix=${D}/usr || die
	ruby install.rb install || die
	dodoc NEWS NOTES README THANKS TODO
	dohtml -r doc/*
	cp -dr guide ${D}/usr/share/doc/${PF}
}
