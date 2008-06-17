# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionmailer/actionmailer-2.1.0.ebuild,v 1.1 2008/06/17 05:38:29 graaff Exp $

inherit ruby gems

DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="http://rubyforge.org/projects/actionmailer/"

LICENSE="MIT"
SLOT="2.1"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="=dev-ruby/actionpack-2.1.0
	>=dev-lang/ruby-1.8.5"
