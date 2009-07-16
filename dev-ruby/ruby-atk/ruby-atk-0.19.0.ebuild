# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-atk/ruby-atk-0.19.0.ebuild,v 1.1 2009/07/16 07:09:48 graaff Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND="dev-libs/atk"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-glib2-${PV}"
