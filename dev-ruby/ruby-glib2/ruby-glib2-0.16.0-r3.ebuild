# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-glib2/ruby-glib2-0.16.0-r3.ebuild,v 1.2 2008/04/06 08:55:34 graaff Exp $

inherit ruby ruby-gnome2 eutils

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND=">=dev-libs/glib-2"

PATCHES="${FILESDIR}/ruby-glib2-0.16.0-glib-2.14.patch \
	${FILESDIR}/ruby-glib2-0.16.0-glib-2.16.patch \
	${FILESDIR}/ruby-glib2-0.16.0-typedef.patch"
