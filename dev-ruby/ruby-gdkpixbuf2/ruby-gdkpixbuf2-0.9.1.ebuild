# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkpixbuf2/ruby-gdkpixbuf2-0.9.1.ebuild,v 1.6 2004/07/03 11:12:29 slarti Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="alpha x86 ppc ~ia64 ~sparc ~amd64"
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND="${DEPEND} >=x11-libs/gtk+-2.0.0"
RDEPEND="${RDEPEND} >=x11-libs/gtk+-2.0.0 >=dev-ruby/ruby-glib2-${PV}"
