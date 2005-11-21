# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rcairo/rcairo-1.0.0.ebuild,v 1.1 2005/11/21 23:58:59 twp Exp $

inherit ruby

IUSE="examples"

DESCRIPTION="Ruby bindings for cairo"
HOMEPAGE="http://cairographics.org"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

SLOT="0"
USE_RUBY="ruby18"
LICENSE="Ruby"
KEYWORDS="~x86"

DEPEND=">=x11-libs/cairo-1.0.0"

src_install() {
	ruby_src_install --prefix=${D}
	if `use examples`; then
		insinto /usr/share/doc/${PF}/samples
		doins samples/*
	fi
}
