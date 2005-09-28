# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gonzui/gonzui-1.2.ebuild,v 1.5 2005/09/28 21:43:26 matsuu Exp $

inherit eutils ruby

USE_RUBY="ruby18 ruby19"

DESCRIPTION="gonzui is a source code search engine."
HOMEPAGE="http://gonzui.sourceforge.net/"
SRC_URI="mirror://sourceforge/gonzui/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="ocaml"

DEPEND=">=virtual/ruby-1.8.2
	>=sys-libs/db-4.2
	>=dev-ruby/ruby-bdb-0.5.2
	dev-ruby/ruby-progressbar
	ocaml? ( dev-lang/ocaml )"
#	perl? ( dev-perl/PPI ) # g-cpan.pl PPI

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/ebuild.rb ${S}/langscan
	sed -i -e "s/rubylib_DATA = /rubylib_DATA = ebuild.rb /" \
		${S}/langscan/Makefile.in || die
}

src_install() {
	ruby_src_install
	mv ${D}/etc/gonzuirc.sample ${D}/etc/gonzuirc
	doinitd ${FILESDIR}/gonzui
	keepdir /var/lib/gonzui
	keepdir /var/log/gonzui
}

pkg_postinst() {
	einfo "The database (gonzui.db) format has become incompatible with"
	einfo "older versions."
	einfo "Please restructure the database if you already have it."
}
