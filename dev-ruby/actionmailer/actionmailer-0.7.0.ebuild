# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionmailer/actionmailer-0.7.0.ebuild,v 1.2 2005/03/08 18:23:15 caleb Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="http://rubyforge.org/projects/actionmailer/"
# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://rubyforge.org/frs/download.php/3199/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=">=dev-ruby/actionpack-1.5.0
	=dev-lang/ruby-1.8*"

