# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord/activerecord-2.2.3.ebuild,v 1.4 2009/10/08 17:56:10 armin76 Exp $

inherit ruby gems
USE_RUBY="ruby18"

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="http://rubyforge.org/projects/activerecord/"

LICENSE="MIT"
SLOT="2.2"
KEYWORDS="amd64 ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="mysql postgres sqlite sqlite3"
RESTRICT="test"

DEPEND=">=dev-lang/ruby-1.8.5
	~dev-ruby/activesupport-2.2.3
	sqlite? ( >=dev-ruby/sqlite-ruby-2.2.2 )
	sqlite3? ( dev-ruby/sqlite3-ruby )
	mysql? ( >=dev-ruby/mysql-ruby-2.7 )
	postgres? ( >=dev-ruby/ruby-postgres-0.7.1 )"
