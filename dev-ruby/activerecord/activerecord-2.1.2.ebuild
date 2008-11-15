# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord/activerecord-2.1.2.ebuild,v 1.6 2008/11/15 18:08:42 dertobi123 Exp $

inherit ruby gems

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="http://rubyforge.org/projects/activerecord/"

LICENSE="MIT"
SLOT="2.1"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="mysql postgres sqlite sqlite3"
RESTRICT="test"

DEPEND=">=dev-lang/ruby-1.8.5
	~dev-ruby/activesupport-2.1.2
	sqlite? ( >=dev-ruby/sqlite-ruby-2.2.2 )
	sqlite3? ( dev-ruby/sqlite3-ruby )
	mysql? ( >=dev-ruby/mysql-ruby-2.7 )
	postgres? ( >=dev-ruby/ruby-postgres-0.7.1 )"
