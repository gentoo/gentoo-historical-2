# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/programming-ruby/programming-ruby-0.4.ebuild,v 1.15 2008/01/27 19:56:40 grobian Exp $

MY_P=ProgrammingRuby-${PV}
DESCRIPTION="Programming Ruby: The Pragmatic Programmers' Guide by Dave Thomas and Andrew Hunt"
HOMEPAGE="http://www.rubycentral.com/"
SRC_URI="http://dev.rubycentral.com/downloads/files/${MY_P}.tgz"
LICENSE="OPL"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${MY_P}

src_install() {
	dodoc README
	dohtml -r .
}
