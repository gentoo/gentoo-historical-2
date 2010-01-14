# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnomeprintui/ruby-gnomeprintui-0.19.3.ebuild,v 1.1 2010/01/14 17:33:13 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby bindings for gnomeprintui"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=gnome-base/libgnomeprintui-2.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

ruby_add_rdepend ">=dev-ruby/ruby-gnomeprint-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"

# Needed to generate rblibgnomeprintversion.h
each_ruby_configure() {
	cd "${WORKDIR}"/ruby-gnome2-all-${PV}/gnomeprint
	ruby extconf.rb || die "ruby-libgnomeprint's extconf.rb failed"

	cd "${WORKDIR}"/ruby-gnome2-all-${PV}/gnomeprintui
	ruby extconf.rb || die "ruby-libgnomeprintui's extconf.rb failed"
}
