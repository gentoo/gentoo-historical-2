# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/net-ssh/net-ssh-1.0.2.ebuild,v 1.1 2005/08/10 15:27:41 citizen428 Exp $

inherit ruby

DESCRIPTION="Non-interactive SSH processing in pure Ruby"
HOMEPAGE="http://net-ssh.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/5307/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

USE_RUBY="ruby18"

DEPEND=">=dev-lang/ruby-1.8.2"
RDEPEND="dev-ruby/needle"

