# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionwebservice/actionwebservice-1.2.6.ebuild,v 1.3 2007/11/26 23:26:54 ranger Exp $

inherit ruby gems

DESCRIPTION="Simple Support for Web Services APIs for Rails"
HOMEPAGE="http://rubyforge.org/projects/aws/"

LICENSE="MIT"
SLOT="1.2"
KEYWORDS="~amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.5
	=dev-ruby/actionpack-1.13.6
	=dev-ruby/activerecord-1.15.6"
