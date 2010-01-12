# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-rails/rspec-rails-1.3.0.ebuild,v 1.2 2010/01/12 16:23:03 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18"

# would be spec, but it needs to be in the same filesystem tree as
# rspec (and cannot use the install-reduced code), so we cannot run
# them for now.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Contribute.rdoc History.rdoc README.rdoc Upgrade.rdoc TODO.txt"

RUBY_FAKEGEM_EXTRAINSTALL="generators"

inherit ruby-fakegem

DESCRIPTION="RSpec's official Ruby on Rails plugin"
HOMEPAGE="http://rspec.info/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rspec-1.3.0 >=dev-ruby/rack-1.0.0"

# Without this the whole Rakefile fails, so it's a general dependency
# and not just a test dependency.
ruby_add_bdepend doc dev-util/cucumber
