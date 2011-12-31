# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mysql2/mysql2-0.3.7.ebuild,v 1.2 2011/12/31 20:48:44 grobian Exp $

EAPI="3"
USE_RUBY="ruby18 ree18"

# Tests require a live MySQL database.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit multilib ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql."
HOMEPAGE="https://github.com/brianmario/mysql2"

LICENSE="MIT"
SLOT="0.3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="${DEPEND} virtual/mysql[-static]"
RDEPEND="${RDEPEND} virtual/mysql[-static]"

each_ruby_configure() {
	${RUBY} -Cext/mysql2 extconf.rb --with-mysql-config "${EPREFIX}/usr/bin/mysqlconfig" || die
}

each_ruby_compile() {
	emake -Cext/mysql2 || die
	cp ext/mysql2/mysql2$(get_modname) lib/mysql2/ || die
}
