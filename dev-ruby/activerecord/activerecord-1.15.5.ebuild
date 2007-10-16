# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord/activerecord-1.15.5.ebuild,v 1.3 2007/10/16 13:23:22 armin76 Exp $

inherit ruby gems

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="http://rubyforge.org/projects/activerecord/"

LICENSE="MIT"
SLOT="1.2"
KEYWORDS="~amd64 ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/ruby-1.8.5
	=dev-ruby/activesupport-1.4.4"
