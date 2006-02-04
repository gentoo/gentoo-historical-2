# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amstd/amstd-2.0.0.ebuild,v 1.9 2006/02/04 15:03:00 solar Exp $

DESCRIPTION="Ruby utility collection by Minero Aoki"
HOMEPAGE="http://www.loveruby.net/en/amstd.html"
SRC_URI="http://www.loveruby.net/archive/amstd/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha hppa mips sparc x86"
IUSE=""
DEPEND="virtual/ruby"

src_compile() {
	ruby install.rb config --prefix=/usr || die
	ruby install.rb setup || die
}

src_install () {
	ruby install.rb config --prefix=${D}/usr || die
	ruby install.rb install || die
}
