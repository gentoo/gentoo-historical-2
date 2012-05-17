# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rack-protection/rack-protection-1.2.0.ebuild,v 1.3 2012/05/17 10:57:55 tomka Exp $

EAPI=4
USE_RUBY="ruby18 ree18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="rack-protection.gemspec"

inherit ruby-fakegem eutils versionator

DESCRIPTION="This gem protects against typical web attacks."
HOMEPAGE="https://github.com/rkh/rack-protection"

LICENSE="MIT"
SLOT="$(get_version_component_range 1)"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rack-test dev-ruby/rspec:2 )"
