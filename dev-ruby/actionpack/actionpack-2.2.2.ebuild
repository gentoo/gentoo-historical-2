# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionpack/actionpack-2.2.2.ebuild,v 1.1 2008/11/27 06:56:27 graaff Exp $

inherit ruby gems

DESCRIPTION="Eases web-request routing, handling, and response."
HOMEPAGE="http://rubyforge.org/projects/actionpack/"

LICENSE="MIT"
SLOT="2.2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.5
	=dev-ruby/activesupport-2.2.2"
