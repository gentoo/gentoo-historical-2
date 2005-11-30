# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-ldap/ruby-ldap-0.9.1.ebuild,v 1.1 2005/03/16 15:27:33 caleb Exp $

inherit ruby

DESCRIPTION="A Ruby interface to some LDAP libraries"
HOMEPAGE="http://ruby-ldap.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-ldap/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~ppc ~sparc ~x86"
IUSE="ssl"
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND=">=net-nds/openldap-2
	ssl? ( dev-libs/openssl )"

src_compile() {
	ruby extconf.rb --with-openldap2 || die "extconf.rb failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ChangeLog README* TODO
}
