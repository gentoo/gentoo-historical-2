# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rake/rake-0.8.7-r1.ebuild,v 1.1 2009/08/22 20:24:08 graaff Exp $

inherit bash-completion gems

USE_RUBY="ruby18 ruby19"

DESCRIPTION="Make-like scripting in Ruby"
HOMEPAGE="http://rake.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="bash-completion"

src_install() {
	gems_src_install
	dobashcompletion "${FILESDIR}"/rake.bash-completion rake
}
