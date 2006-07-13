# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bluecloth/bluecloth-1.0.0.ebuild,v 1.6 2006/07/13 05:14:11 agriffis Exp $

inherit ruby gems

MY_P="BlueCloth-${PV}"
DESCRIPTION="A Ruby implementation of Markdown"
HOMEPAGE="http://www.deveiate.org/projects/BlueCloth"
SRC_URI="http://www.deveiate.org/code/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ia64 ppc x86"
IUSE=""

USE_RUBY="ruby18"
DEPEND=">=dev-lang/ruby-1.8"

S=${WORKDIR}/${MY_P}

pkg_postinst() {
	einfo "This package was installed using a 'gem'."
	einfo "If you are intending to write code which"
	einfo "requires ${PN}, you will need to"
	einfo
	einfo "require 'rubygems'"
	einfo
	einfo "before requiring '${PN}'."
}
