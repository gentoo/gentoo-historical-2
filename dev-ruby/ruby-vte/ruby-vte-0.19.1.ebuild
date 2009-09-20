# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-vte/ruby-vte-0.19.1.ebuild,v 1.2 2009/09/20 14:39:36 graaff Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby vte bindings"
KEYWORDS="~amd64 ~x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND=">=x11-libs/vte-0.12.1
	>=dev-ruby/ruby-gtk2-${PV}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-vte-depend.patch )
