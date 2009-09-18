# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_ruby/mod_ruby-1.3.0.ebuild,v 1.1 2009/09/18 14:12:07 hollow Exp $

inherit apache-module

DESCRIPTION="Embeds the Ruby interpreter into Apache."
HOMEPAGE="http://modruby.net/"
SRC_URI="http://modruby.net/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

RDEPEND="virtual/ruby"
DEPEND="${RDEPEND}
	doc? ( dev-ruby/rdtool )"

APACHE2_MOD_CONF="21_mod_ruby"
APACHE2_MOD_DEFINE="RUBY"
APACHE2_MOD_FILE="${PN}.so"

DOCFILES="ChangeLog COPYING README.*"

need_apache2_2

src_compile() {
	./configure.rb \
		--with-apxs=${APXS} \
		--with-apr-includes=$(/usr/bin/apr-1-config --includedir)

	emake || die "emake failed"

	if use doc ; then
		cd doc
		emake || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc ; then
		dohtml doc/*.css doc/*.html
	fi

	apache-module_src_install
}
