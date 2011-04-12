# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber/cucumber-0.10.2.ebuild,v 1.1 2011/04/12 20:25:11 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ree18"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64"
SLOT="0"
IUSE="examples"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-2.5.0
		>=dev-ruby/nokogiri-1.4.4
		>=dev-ruby/prawn-layout-0.8.4
		>=dev-ruby/spork-0.8.4-r1
		>=dev-ruby/syntax-1.0.0
		>=dev-util/aruba-0.3.4
	)"
# simplecov 0.4.1?

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/diff-lcs-1.1.2
	>=dev-ruby/gherkin-2.3.5
	>=dev-ruby/json-1.4.6
	>=dev-ruby/term-ansicolor-1.0.5
"

all_ruby_prepare() {
#	epatch "${FILESDIR}/${P}-ruby-1.8.7.patch"
#	epatch "${FILESDIR}/${P}-gherkin-2.3.3.patch"

	# Remove Bundler-related things.
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
	rm Gemfile || die

	# Make sure spork is run in the right interpreter
	sed -i -e 's/#{Spork::BINARY}/-S #{Spork::BINARY}/' features/support/env.rb || die

	# json has already moved on, match this
	sed -i -e 's/~> 1.4.6/>= 1.4.6/' cucumber.gemspec || die "Unable to fix json requirement"
}

each_ruby_test() {
	${RUBY} -S rspec spec || die "Specs failed"
	${RUBY} -Ilib bin/cucumber features || die "Features failed"
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}
