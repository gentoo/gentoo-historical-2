# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fxruby/fxruby-1.0.29.ebuild,v 1.5 2005/09/02 12:48:05 flameeyes Exp $

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
	>=x11-libs/fox-1.0 <x11-libs/fox-1.2
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
	cp -r examples ${D}/usr/share/doc/${PF}
	dohtml -r doc/*
}
