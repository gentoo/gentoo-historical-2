# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-xslt/ruby-xslt-0.9.3.ebuild,v 1.6 2007/10/31 06:27:57 graaff Exp $

RUBY_BUG_145222=yes
inherit ruby

MY_P="${PN}_${PV}"

DESCRIPTION="A Ruby class for processing XSLT"
HOMEPAGE="http://www.rubyfr.net/"
SRC_URI="http://gregoire.lejeune.free.fr/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc64 ~x86"
IUSE="examples"

# Some tests are broken, see bug #191513. Restrict until this is fixed
# either by a patch or in a new version upstream.
RESTRICT="test"

USE_RUBY="ruby18 ruby19"

DEPEND=">=dev-lang/ruby-1.8
	>=dev-libs/libxslt-1.1.12"

S="${WORKDIR}/${PN}"
