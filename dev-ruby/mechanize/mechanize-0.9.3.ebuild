# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mechanize/mechanize-0.9.3.ebuild,v 1.1 2009/06/29 06:14:14 graaff Exp $

inherit ruby gems

USE_RUBY="ruby18 ruby19"

DESCRIPTION="A Ruby library used for automating interaction with websites."
HOMEPAGE="http://mechanize.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-ruby/nokogiri-1.2.1
		>=dev-ruby/rubygems-1.3.1
		>=dev-lang/ruby-1.8.4"
RDEPEND="${DEPEND}"
