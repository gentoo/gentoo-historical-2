# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails/rails-0.11.0-r1.ebuild,v 1.1 2005/03/25 04:15:10 pythonhead Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="ruby on rails is a web-application and persistance framework"
HOMEPAGE="http://www.rubyonrails.org"
# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://rubyforge.org/frs/download.php/3590/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"

IUSE="mysql sqlite postgres"
DEPEND="=dev-lang/ruby-1.8*
	>=dev-ruby/rake-0.4.15-r1
	>=dev-ruby/activerecord-1.9.0
	>=dev-ruby/actionmailer-0.8.0
	>=dev-ruby/actionwebservice-0.6.1
	sqlite? ( >=dev-ruby/sqlite-ruby-2.2.2)
	mysql? ( >=dev-ruby/mysql-ruby-2.5 )
	postgres? ( >=dev-ruby/ruby-postgres-0.7.1 )"

src_install() {
	gems_src_install
	cd ${D}/usr/lib/ruby/gems/1.8/gems/${P}
	#Fixes fastcgi bug where RAILS_ROOT isn't defined
	epatch ${FILESDIR}/${P}-dispatch.fcgi.diff
}

pkg_postinst() {
	einfo "If you have an existing Rails 0.9.5 application you'd like to"
	einfo "upgrade to 0.11.0 please follow these instructions:"
	einfo "http://manuals.rubyonrails.com/read/book/15"
	einfo "*"
	einfo "If you need to upgrade an existing 0.10.* app to 0.11.0 cd to the app's"
	einfo "directory and run 'rails . --skip'"

}

