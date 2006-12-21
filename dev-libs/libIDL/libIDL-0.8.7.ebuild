# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libIDL/libIDL-0.8.7.ebuild,v 1.6 2006/12/21 12:25:29 corsair Exp $

inherit eutils gnome2

DESCRIPTION="CORBA tree builder"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc-macos ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-1.3.7"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	dev-util/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README"

src_unpack() {
	gnome2_src_unpack
	epunt_cxx
}
