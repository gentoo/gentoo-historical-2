# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkpixbuf2/ruby-gdkpixbuf2-0.7.0.ebuild,v 1.3 2004/06/25 01:59:09 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="~alpha ~x86"
DEPEND="${DEPEND} >=x11-libs/gtk+-2.0.0"
RDEPEND="${RDEPEND} >=x11-libs/gtk+-2.0.0 >=dev-ruby/ruby-glib2-${PV}"
