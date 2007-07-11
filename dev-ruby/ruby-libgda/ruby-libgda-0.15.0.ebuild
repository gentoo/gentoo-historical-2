# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libgda/ruby-libgda-0.15.0.ebuild,v 1.2 2007/07/11 05:23:08 mr_bones_ Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby libgda (GNOME-DB) bindings"
KEYWORDS="~alpha ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=gnome-extra/libgda-1.0.3"
RDEPEND=">=dev-ruby/ruby-glib2-${PV}"
