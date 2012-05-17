# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/jquery-rails/jquery-rails-2.0.2.ebuild,v 1.2 2012/05/17 10:57:04 tomka Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 ree18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="vendor"

RUBY_FAKEGEM_GEMSPEC="jquery-rails.gemspec"

inherit ruby-fakegem

DESCRIPTION="jQuery! For Rails! So great."
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~x64-macos"

IUSE=""

ruby_add_rdepend ">=dev-ruby/railties-3.2.0 >=dev-ruby/thor-0.14"
