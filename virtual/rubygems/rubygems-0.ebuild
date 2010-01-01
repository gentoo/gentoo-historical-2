# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/rubygems/rubygems-0.ebuild,v 1.5 2010/01/01 16:26:53 flameeyes Exp $

EAPI=2
USE_RUBY="ruby18 ruby19"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby gems tools"
HOMEPAGE="http://www.rubygems.org/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="ruby_targets_ruby18? ( dev-ruby/rubygems )
	ruby_targets_ruby19? ( dev-lang/ruby:1.9 )"
DEPEND=""
