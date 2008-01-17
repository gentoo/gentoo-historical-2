# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-poppler/ruby-poppler-0.16.0.ebuild,v 1.2 2008/01/17 16:11:01 flameeyes Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby poppler-glib bindings"
KEYWORDS="~amd64 ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=app-text/poppler-bindings-0.5.2
	dev-ruby/ruby-gdkpixbuf2
	>=dev-ruby/ruby-glib2-${PV}
	dev-util/pkgconfig"
pkg_setup()
{
	pkg-config --exists poppler-glib ||
		die "You have to emerge poppler-bindings with USE flag gtk"
}
