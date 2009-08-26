# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-dbi/ruby-dbi-0.4.2.ebuild,v 1.1 2009/08/26 22:17:15 a3li Exp $

inherit "ruby"

MY_P=${P##ruby-}

DESCRIPTION="Ruby/DBI - a database independent interface for accessing databases - similar to Perl's DBI"
HOMEPAGE="http://ruby-dbi.rubyforge.org"
SRC_URI="mirror://rubyforge/ruby-dbi/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples odbc postgres mysql sqlite sqlite3 test"

DEPEND="
	virtual/ruby
	dev-ruby/deprecated
	test? ( dev-ruby/test-unit )"
RDEPEND="${DEPEND}"
PDEPEND="
	mysql?    ( dev-ruby/dbd-mysql )
	postgres? ( dev-ruby/dbd-pg )
	odbc?     ( dev-ruby/dbd-odbc )
	sqlite?   ( dev-ruby/dbd-sqlite )
	sqlite3?  ( dev-ruby/dbd-sqlite3 )"

S="${WORKDIR}/${MY_P}"
USE_RUBY="ruby18 ruby19"

src_test() {
	for rb in $USE_RUBY; do
		ebegin "Testing for ${rb}"
		${rb} setup.rb test || die "test failed"
		eend $?
	done
}

src_install() {
	ruby setup.rb install \
		--prefix="${D}" || die

	dodoc README

	if use examples ; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "cp examples failed"
	fi
}

pkg_postinst() {
	if ! (use mysql || use postgres || use odbc || use sqlite || use sqlite3)
	then
		elog "${P} now comes with external database drivers."
		elog "Be sure to set the right USE flags for ${PN} or emerge the drivers manually:"
		elog "They are called dev-ruby/dbd-{mysql,odbc,pg,sqlite,sqlite3}"
	fi
}
