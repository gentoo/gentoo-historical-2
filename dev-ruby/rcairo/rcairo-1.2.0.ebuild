# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rcairo/rcairo-1.2.0.ebuild,v 1.7 2007/03/04 18:15:45 opfer Exp $

RUBY_BUG_145222=yes
inherit ruby

IUSE="examples"

DESCRIPTION="Ruby bindings for cairo"
HOMEPAGE="http://cairographics.org"
SRC_URI="http://cairographics.org/releases/${P}.tar.gz"

SLOT="0"
USE_RUBY="ruby18"
LICENSE="Ruby"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~sparc x86"

DEPEND=">=x11-libs/cairo-1.2.0"
PATCHES="${FILESDIR}/${P}-no-svg.patch"

src_install() {
	ruby_src_install --prefix="${D}"
	if `use examples`; then
		insinto /usr/share/doc/${PF}/samples
		doins samples/*
	fi
}
