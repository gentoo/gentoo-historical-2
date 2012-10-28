# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/yard/yard-0.8.3.ebuild,v 1.2 2012/10/28 16:10:38 jer Exp $

EAPI=4

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_EXTRADOC="README.md ChangeLog"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRAINSTALL="templates"

inherit ruby-fakegem

DESCRIPTION="Documentation generation tool for the Ruby programming language"
HOMEPAGE="http://yardoc.org/"

# The gem lakes the gemspec file needed to pass tests.
SRC_URI="https://github.com/lsegal/yard/tarball/${PV} -> ${P}-git.tgz"
RUBY_S="lsegal-yard-*"

LICENSE="as-is" # truly
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

#RUBY_PATCHES=( ${P}-test-failures.patch )

ruby_add_bdepend "doc? ( || ( dev-ruby/bluecloth dev-ruby/maruku dev-ruby/rdiscount dev-ruby/kramdown ) )"

ruby_add_bdepend "test? ( dev-ruby/ruby-gettext )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e "s/require 'bundler'; rescue LoadError//" spec/cli/server_spec.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# This spec requires rdiscount which is a C extension.
			sed -i -e '150s/should/should_not/' spec/templates/helpers/html_helper_spec.rb || die
			sed -i -e '/should return file contents if found/,/end/ s:^:#:' spec/server/commands/static_file_command_spec.rb || die
			;;
		*)
			;;
	esac
}
