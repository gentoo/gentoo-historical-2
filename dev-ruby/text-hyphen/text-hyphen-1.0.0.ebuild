# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/text-hyphen/text-hyphen-1.0.0.ebuild,v 1.9 2008/10/28 01:46:25 ranger Exp $

inherit ruby gems

DESCRIPTION="Hyphenates various words according to the rules of the language the word is written in."
HOMEPAGE="http://rubyforge.org/projects/text-format"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE=""

DEPEND="virtual/ruby"
