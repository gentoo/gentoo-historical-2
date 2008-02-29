# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-postgres/ruby-postgres-0.7.1.20051221-r1.ebuild,v 1.4 2008/02/29 16:00:30 jer Exp $

inherit ruby gems

MY_P=ruby-postgres-0.7.1.2005.12.21

DESCRIPTION="An extension library to access a PostgreSQL database from Ruby"
HOMEPAGE="http://ruby.scripting.ca/postgres"
SRC_URI="http://ruby.scripting.ca/postgres/archive/${MY_P}.gem"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
USE_RUBY="ruby18"

RDEPEND=">=dev-db/libpq-6.4"
DEPEND="${RDEPEND}
	>=dev-ruby/rubygems-0.9.0-r1"
