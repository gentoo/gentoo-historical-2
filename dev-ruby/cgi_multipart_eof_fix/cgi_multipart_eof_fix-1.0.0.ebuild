# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/cgi_multipart_eof_fix/cgi_multipart_eof_fix-1.0.0.ebuild,v 1.4 2007/02/01 06:54:12 corsair Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Fix an exploitable bug in CGI multipart parsing which affects Ruby
<= 1.8.5"
# Mongrel hosts gem_plugin, so setting that as homepage
HOMEPAGE="http://mongrel.rubyforge.org/"
SRC_URI="http://mongrel.rubyforge.org/releases/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
