# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-2.11.1.ebuild,v 1.13 2010/07/20 02:20:21 jer Exp $

inherit eutils gnome2 versionator autotools

MY_P="lib${P}"
MY_PN="lib${PN}"
MY_MAJ_PV="$(get_version_component_range 1-2)"

DESCRIPTION="a Gtk+ based HTML rendering library"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${MY_MAJ_PV}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="accessibility test"

# gnome-vfs is only needed to run testgtkhtml (1/3 tests)

RDEPEND=">=x11-libs/gtk+-2.13.0
	>=dev-libs/libxml2-2.4.16
	test? ( >=gnome-base/gnome-vfs-2 )"
DEPEND="${RDEPEND}
	 >=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog NEWS README TODO docs/IDEAS"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable accessibility)"
}

src_unpack() {
	gnome2_src_unpack

	if use alpha; then
		epatch "${FILESDIR}/${MY_PN}-2.2.0-alpha.patch"
	fi

	if use x86-fbsd; then
		# We need a full autoreconf on FreeBSD at least to fix libtool errors.
		eautoreconf
	fi
}
