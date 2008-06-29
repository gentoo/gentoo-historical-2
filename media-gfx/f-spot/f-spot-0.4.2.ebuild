# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/f-spot/f-spot-0.4.2.ebuild,v 1.3 2008/06/29 10:21:06 tove Exp $

inherit gnome2 mono autotools

DESCRIPTION="Personal photo management application for the gnome desktop"
HOMEPAGE="http://f-spot.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1.10
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2.6
	>=dev-dotnet/gtk-sharp-2.8
	>=dev-dotnet/dbus-sharp-0.4.2
	>=dev-dotnet/dbus-glib-sharp-0.3.0
	>=dev-dotnet/gtkhtml-sharp-2.7
	>=dev-dotnet/gconf-sharp-2.7
	>=dev-dotnet/glade-sharp-2.7
	>=dev-dotnet/gnomevfs-sharp-2.7
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2
	>=media-libs/libexif-0.6.16
	<media-libs/libexif-0.7.0
	>=media-libs/libgphoto2-2.1.4
	>=media-libs/lcms-1.15
	media-libs/jpeg
	>=dev-db/sqlite-3"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

MAKEOPTS="${MAKEOPTS} -j1"

# See bug #203566
RESTRICT="test"

src_unpack() {
	gnome2_src_unpack
	cd "${S}"

	# Fix http://bugzilla.gnome.org/show_bug.cgi?id=517193
	epatch "${FILESDIR}"/${P}-color-adjust.patch

	# Disable Beagle
	sed -i -e '/PKG_CHECK_MODULES.*BEAGLE/,/AC_SUBST.*LINK_BEAGLE/ d' configure.in || die "sed failed"

	eautoreconf
	intltoolize --force || die "intltoolize --force failed"
}
