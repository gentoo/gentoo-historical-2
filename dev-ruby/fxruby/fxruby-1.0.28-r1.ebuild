# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fxruby/fxruby-1.0.28-r1.ebuild,v 1.3 2004/06/22 15:36:14 usata Exp $

inherit ruby

MY_P=FXRuby-${PV}
DESCRIPTION="Ruby language binding to the FOX GUI toolkit"
HOMEPAGE="http://www.fxruby.org/"
SRC_URI="mirror://sourceforge/fxruby/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-alpha -hppa ~sparc ~x86 ~ppc"
IUSE=""
DEPEND="virtual/ruby
	>=x11-libs/fox-1.0
	x11-libs/fxscintilla"
USE_RUBY="ruby16 ruby18 ruby19"
S=${WORKDIR}/${MY_P}

src_compile() {
	ruby install.rb config --prefix=/usr || die
	ruby install.rb setup || die
}

src_install() {
	ruby install.rb config --prefix=${D}/usr || die
	ruby install.rb install || die

	dodoc ANNOUNCE ChangeLog README*
	cp -dr examples ${D}/usr/share/doc/${PF}
	dohtml -r doc/*
}
