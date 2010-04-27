# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hoe/hoe-2.6.0.ebuild,v 1.3 2010/04/27 04:50:10 mr_bones_ Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt Manifest.txt README.txt"

RUBY_FAKEGEM_EXTRAINSTALL="template"

inherit ruby-fakegem

DESCRIPTION="Hoe extends rake to provide full project automation."
HOMEPAGE="http://seattlerb.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

# - also requires dev-ruby/hoe-seattlerb for 1.9;
# - dev-ruby/gemcutter is an optional dependency at both runtime and
#   test-time, at least for us;
# - rubyforge is loaded at runtime when needed, so we don't strictly
#   depend on it at runtime, but we need it for tests (for now);
ruby_add_bdepend test "virtual/ruby-minitest >=dev-ruby/rubyforge-2.0.3"

ruby_add_rdepend ">=dev-ruby/rake-0.8.7"

all_ruby_compile() {
	mkdir "${HOME}/.rubyforge" || die
	touch "${HOME}/.rubyforge/user-config.yml" || die

	all_fakegem_compile
}

each_ruby_test() {
	mkdir "${HOME}/.rubyforge" || die
	touch "${HOME}/.rubyforge/user-config.yml" || die

	each_fakegem_test
}
