# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/addressable/addressable-2.2.8.ebuild,v 1.1 2012/05/08 18:25:08 graaff Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 jruby ree18"

RUBY_FAKEGEM_TASK_DOC="doc:yard"
RUBY_FAKEGEM_TASK_TEST="spec:normal"

RAKE_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="A replacement for the URI implementation that is part of Ruby's standard library."
HOMEPAGE="http://addressable.rubyforge.org/"

LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "test? ( dev-ruby/rspec:2 )"

all_ruby_prepare() {
	# Remove spec-related tasks so that we don't need to require rspec
	# just to build the documentation, bug 383611.
	sed -i -e '/spectask/d' Rakefile || die
	rm tasks/rspec.rake || die
}

each_ruby_test() {
	${RUBY} -I lib -S rspec spec || die "Tests failed."
}
