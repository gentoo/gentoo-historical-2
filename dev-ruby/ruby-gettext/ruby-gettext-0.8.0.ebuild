# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gettext/ruby-gettext-0.8.0.ebuild,v 1.5 2005/10/06 12:59:05 caleb Exp $

inherit ruby

DESCRIPTION="Ruby GetText Package is Native Language Support Library and Tools which modeled after GNU gettext package"
HOMEPAGE="http://ponx.s5.xrea.com/hiki/ruby-gettext.html"
# The source tarball was downloaded from the site above
SRC_URI="mirror://gentoo/${PN}-package-${PV}.tar.gz"

KEYWORDS="x86 ppc ~amd64"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"
SLOT="0"
LICENSE="Ruby"

DEPEND="|| ( >=dev-lang/ruby-1.8 dev-lang/ruby-cvs )
	sys-devel/gettext
	dev-ruby/rdtool
	>=dev-ruby/racc-1.4.4"

S="${WORKDIR}/${PN}-package-${PV}"
