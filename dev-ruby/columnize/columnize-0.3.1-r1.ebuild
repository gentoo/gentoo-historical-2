# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/columnize/columnize-0.3.1-r1.ebuild,v 1.2 2010/01/04 11:11:26 fauli Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRADOC="AUTHORS ChangeLog NEWS README"

inherit ruby-fakegem

DESCRIPTION="Sorts an array in column order."
HOMEPAGE="http://rubyforge.org/projects/rocky-hacks/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend test virtual/ruby-test-unit
