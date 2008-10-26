# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk2/ruby-gtk2-0.16.0-r4.ebuild,v 1.2 2008/10/26 14:39:25 nixnut Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=x11-libs/gtk+-2"
RDEPEND="${DEPEND}
	dev-ruby/ruby-gdkpixbuf2
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-pango-${PV}
	>=dev-ruby/ruby-atk-${PV}"

PATCHES=( "${FILESDIR}"/ruby-gtk2-0.16.0-typedef.patch
	"${FILESDIR}"/ruby-gtk2-0.16.0-format-string.patch
	"${FILESDIR}"/${P}-iconview-get-path.patch
	"${FILESDIR}"/${P}-gtk-file-system-error.patch )
