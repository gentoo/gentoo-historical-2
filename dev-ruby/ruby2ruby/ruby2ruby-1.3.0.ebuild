# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby2ruby/ruby2ruby-1.3.0.ebuild,v 1.2 2012/08/16 04:01:35 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ree18"

# Don't run tests, since they require the testcase from ParseTree;
# ParseTree _is_ the testcase for ruby2ruby
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="Generates readable ruby from ParseTree"
HOMEPAGE="http://seattlerb.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "=dev-ruby/parsetree-3.0*
	=dev-ruby/sexp_processor-3.0*
	=dev-ruby/ruby_parser-2.0*"
ruby_add_bdepend doc "dev-ruby/hoe dev-ruby/hoe-seattlerb"

all_ruby_prepare() {
	sed -i -e '/isolate/d' Rakefile || die
}
