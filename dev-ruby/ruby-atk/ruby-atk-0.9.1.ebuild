# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-atk/ruby-atk-0.9.1.ebuild,v 1.1 2004/03/20 15:33:41 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="~alpha ~x86 ~ppc ~ia64"
DEPEND="${DEPEND} dev-libs/atk"
RDEPEND="${RDEPEND} dev-libs/atk >=dev-ruby/ruby-glib2-${PV}"
