# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dpklib/dpklib-1.0.6.ebuild,v 1.1 2005/09/20 17:13:13 killerfox Exp $

inherit ruby

USE_RUBY="ruby16 ruby18 ruby19"

DESCRIPTION="dpklib is the miscellany library for Ruby including sample executable scripts."
HOMEPAGE="http://devel.korinkan.co.jp/dpklib/"
SRC_URI="http://devel.korinkan.co.jp/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/ruby"

src_compile() {
	ruby install.rb config || die 'install.rb config failed'
	ruby install.rb setup || die 'install.rb setup failed'
}

src_install() {
	ruby install.rb config --prefix=${D}/usr || die 'install.rb config failed'
	ruby install.rb install || die 'install.rb install failed'
	dodoc README
	docinto samples
	dodoc samples/*
}

