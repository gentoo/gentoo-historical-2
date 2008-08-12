# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/mongrel/mongrel-1.1.5.ebuild,v 1.1 2008/08/12 05:49:58 graaff Exp $

inherit gems

DESCRIPTION="A small fast HTTP library and server that runs Rails, Camping, and Nitro apps"
HOMEPAGE="http://mongrel.rubyforge.org/"

LICENSE="mongrel"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="any"
DEPEND=">=dev-ruby/daemons-1.0.3
	>=dev-ruby/gem_plugin-0.2.3
	>=dev-ruby/fastthread-1.0.1
	>=dev-ruby/cgi_multipart_eof_fix-2.4"
