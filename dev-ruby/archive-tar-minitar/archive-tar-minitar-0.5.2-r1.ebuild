# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/archive-tar-minitar/archive-tar-minitar-0.5.2-r1.ebuild,v 1.3 2010/01/14 15:32:54 ranger Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README ChangeLog"

inherit ruby-fakegem

DESCRIPTION="Provides POSIX tarchive management from Ruby programs."
HOMEPAGE="http://rubyforge.org/projects/ruwiki/"
SRC_URI="mirror://rubyforge/ruwiki/${P}.tar.gz"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RESTRICT="test"
