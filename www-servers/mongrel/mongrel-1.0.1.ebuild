# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/mongrel/mongrel-1.0.1.ebuild,v 1.5 2007/02/24 10:19:23 corsair Exp $

inherit ruby gems

DESCRIPTION="A small fast HTTP library and server that runs Rails, Camping, and Nitro apps"
HOMEPAGE="http://mongrel.rubyforge.org/"
SRC_URI="http://mongrel.rubyforge.org/releases/gems/${P}.gem"

LICENSE="mongrel"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="any"
DEPEND=">=dev-ruby/daemons-1.0.3
	>=dev-ruby/gem_plugin-0.2.1
	>=dev-ruby/fastthread-0.6.2
	>=dev-ruby/cgi_multipart_eof_fix-0.2.1"
