# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/trollop/trollop-1.16.2.ebuild,v 1.3 2010/05/28 20:17:07 josejx Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="FAQ.txt History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Trollop is a commandline option parser for Ruby."
HOMEPAGE="http://trollop.rubyforge.org/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE=""

each_ruby_test() {
	${RUBY} -I lib test/test_trollop.rb || die "Tests failed."
}
