# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/builder/builder-3.0.0.ebuild,v 1.1 2011/01/02 08:53:05 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST="test_all"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README CHANGES"

inherit ruby-fakegem eutils

DESCRIPTION="A builder to facilitate programatic generation of XML markup"
HOMEPAGE="http://rubyforge.org/projects/builder/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( virtual/ruby-test-unit )"

all_ruby_prepare() {
	sed -i -e '/rdoc\.template .*jamis/d' Rakefile || die

	# Remove file that should not be part of the distribution.
	rm test/test_cssbuilder.rb || die
}
