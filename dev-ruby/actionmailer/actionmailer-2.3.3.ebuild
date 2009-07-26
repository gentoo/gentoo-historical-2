# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/actionmailer/actionmailer-2.3.3.ebuild,v 1.2 2009/07/26 06:40:36 graaff Exp $

inherit ruby gems
USE_RUBY="ruby18 ruby19"

DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="http://rubyforge.org/projects/actionmailer/"

LICENSE="MIT"
SLOT="2.3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="~dev-ruby/actionpack-2.3.3
	>=dev-lang/ruby-1.8.6"
RDEPEND="${DEPEND}"
