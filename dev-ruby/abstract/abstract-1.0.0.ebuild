# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/abstract/abstract-1.0.0.ebuild,v 1.1 2010/01/28 23:44:56 flameeyes Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt"

inherit ruby-fakegem

DESCRIPTION="Library which enable you to define abstract method in Ruby."
HOMEPAGE="http://rubyforge.org/projects/abstract"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die "tests failed"
}
