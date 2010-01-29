# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bluecloth/bluecloth-2.0.7.ebuild,v 1.2 2010/01/29 18:47:05 armin76 Exp $

EAPI=2
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_VERSION="${PV/_pre/.pre}"

RUBY_FAKEGEM_EXTRADOC="ChangeLog README"
RUBY_FAKEGEM_DOCDIR="docs/api"

inherit ruby-fakegem eutils

DESCRIPTION="A Ruby implementation of Markdown"
HOMEPAGE="http://www.deveiate.org/projects/BlueCloth"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend ">=dev-ruby/rdoc-2.4.1 dev-ruby/rake-compiler"
ruby_add_bdepend test "dev-ruby/rspec
		dev-ruby/diff-lcs"

all_ruby_prepare() {
	# The Rakefile uses the rubygems' package_task unconditionally,
	# but this breaks when we don't install rubygems proper (like for
	# Ruby 1.9 or JRuby). For this reason, patch it away. It should
	# really be submitted upstream so that, if missing, only the
	# packaging tasks will be ignored.
	sed -i \
		-e '/^\(Gem\|Rake\)::PackageTask/, /^end/ s:^:#:' \
		-e '/package_task/s:^:#:' \
		-e '/task :package/s:^:#:' \
		rake/packaging.rb || die
}

each_ruby_compile() {
	${RUBY} -S rake compile || die "extension build failed"
}
