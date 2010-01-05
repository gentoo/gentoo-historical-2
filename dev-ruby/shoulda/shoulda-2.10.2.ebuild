# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/shoulda/shoulda-2.10.2.ebuild,v 1.1 2010/01/05 17:51:44 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTION_GUIDELINES.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="http://thoughtbot.com/projects/shoulda"
SRC_URI="http://github.com/thoughtbot/${PN}/tarball/v${PV} -> ${P}.tar.gz"
S="${WORKDIR}/thoughtbot-${PN}-87d2e55"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# tests seem to be quite broken :(
RESTRICT=test

#ruby_add_bdepend test "dev-ruby/rails virtual/ruby-test-unit"
