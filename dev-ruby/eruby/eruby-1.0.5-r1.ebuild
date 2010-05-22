# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/eruby/eruby-1.0.5-r1.ebuild,v 1.13 2010/05/22 15:11:59 flameeyes Exp $

inherit ruby

IUSE="vim-syntax examples"

DESCRIPTION="eRuby interprets a Ruby code embedded text file"
HOMEPAGE="http://www.modruby.net/"
SRC_URI="http://www.modruby.net/archive/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 mips ppc ppc64 sparc x86 ~x86-fbsd"
PDEPEND="vim-syntax? ( app-vim/eruby-syntax )"
USE_RUBY="ruby18"	# doesn't build on

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-missing-xldflags.patch
}

src_compile() {
	ruby configure.rb || die
	make || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README*
}
