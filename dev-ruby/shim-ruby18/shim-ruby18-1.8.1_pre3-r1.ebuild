# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/shim-ruby18/shim-ruby18-1.8.1_pre3-r1.ebuild,v 1.1 2004/08/19 17:29:00 usata Exp $

inherit ruby

MY_P="shim-ruby16_18-${PV/_pre/-preview}"

DESCRIPTION="Set of packages that provide Ruby 1.8 features for Ruby 1.6"
HOMEPAGE="http://raa.ruby-lang.org/list.rhtml?name=shim-ruby16_18"
SRC_URI="ftp://ftp.ruby-lang.org/pub/ruby/shim/${MY_P}.tar.bz2"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"

IUSE=""
# don't define USE_RUBY since shim-ruby only supports ruby16
RUBY="/usr/bin/ruby16"

DEPEND="~dev-lang/ruby-1.6.8"

S="${WORKDIR}/shim/ruby16"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-CGI::Session.patch
}

src_install() {

	einstall || die
	erubydoc
	dodoc ${WORKDIR}/shim/README
}
