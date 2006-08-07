# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/diff-lcs/diff-lcs-1.1.2.ebuild,v 1.2 2006/08/07 18:21:12 ticho Exp $

inherit ruby gems

DESCRIPTION="Use the McIlroy-Hunt LCS algorithm to compute differences"
HOMEPAGE="http://raa.ruby-lang.org/project/diff-lcs"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/ruby"
RDEPEND="${DEPEND}
	>=dev-ruby/text-format-0.64"

