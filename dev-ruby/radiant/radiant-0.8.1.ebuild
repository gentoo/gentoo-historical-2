# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/radiant/radiant-0.8.1.ebuild,v 1.1 2009/09/10 11:20:36 graaff Exp $

inherit ruby gems

DESCRIPTION="A no-fluff, open source content management system"
HOMEPAGE="http://radiantcms.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
USE_RUBY="ruby18"

DEPEND="
	>=dev-ruby/redcloth-4.0.0
	>=dev-ruby/rack-1.0.0
	>=dev-ruby/rake-0.8.3"
RDEPEND="${DEPEND}"
