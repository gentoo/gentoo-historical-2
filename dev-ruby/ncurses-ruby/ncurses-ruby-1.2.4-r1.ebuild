# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ncurses-ruby/ncurses-ruby-1.2.4-r1.ebuild,v 1.9 2012/05/01 18:24:06 armin76 Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changes README THANKS TODO"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby wrappers of ncurses and PDCurses libs"
HOMEPAGE="http://ncurses-ruby.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ppc ppc64 x86"
IUSE="examples"

DEPEND=">=sys-libs/ncurses-5.3[-trace]"
RDEPEND="${DEPEND}"

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	emake || die
	mv ncurses_bin$(get_modname) lib/ || die
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die
	fi
}
