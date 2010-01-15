# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/coderay/coderay-0.8.260.ebuild,v 1.4 2010/01/15 20:33:10 armin76 Exp $

inherit ruby gems

DESCRIPTION="A Ruby library for syntax highlighting."
HOMEPAGE="http://coderay.rubychan.de/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"
RDEPEND="${DEPEND}"
