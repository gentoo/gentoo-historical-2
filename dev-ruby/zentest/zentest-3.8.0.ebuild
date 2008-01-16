# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.8.0.ebuild,v 1.1 2008/01/16 03:26:27 nichoj Exp $

inherit gems

MY_P=${P/zentest/ZenTest}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="http://rubyforge.org/projects/zentest/"
LICENSE="Ruby"

SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE=""

DEPEND=">=dev-ruby/hoe-1.4.0"
