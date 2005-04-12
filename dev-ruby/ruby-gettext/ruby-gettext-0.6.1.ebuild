# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gettext/ruby-gettext-0.6.1.ebuild,v 1.4 2005/04/12 04:57:25 usata Exp $

inherit ruby

DESCRIPTION="Ruby GetText Package is Native Language Support Library and Tools which modeled after GNU gettext package"
HOMEPAGE="http://ponx.s5.xrea.com/hiki/ruby-gettext.html"
# The source tarball was downloaded from the site above
SRC_URI="mirror://gentoo/${PN}-package-${PV}.tar.gz"

KEYWORDS="x86 ppc"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"
SLOT="0"
LICENSE="Ruby"

DEPEND="|| ( >=dev-lang/ruby-1.8 dev-lang/ruby-cvs dev-ruby/shim-ruby18 )
	sys-devel/gettext
	dev-ruby/rdtool
	>=dev-ruby/racc-1.4.4"

S="${WORKDIR}/${PN}-package-${PV}"
