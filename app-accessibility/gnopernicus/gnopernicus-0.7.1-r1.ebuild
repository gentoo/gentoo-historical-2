# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/gnopernicus/gnopernicus-0.7.1-r1.ebuild,v 1.3 2004/05/31 18:45:21 vapier Exp $

inherit gnome2

DESCRIPTION="Software tools for blind and visually impaired in Gnome 2"
HOMEPAGE="http://www.baum.ro/gnopernicus.html"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa ~amd64 ia64"
IUSE="ipv6"

# libgail-gnome is only required during runtime
RDEPEND=">=gnome-base/gconf-2
	>=dev-libs/popt-1.5
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=dev-libs/glib-2
	>=x11-libs/gtk+-1.3
	>=dev-libs/libxml2-2
	>=gnome-base/libglade-1.99.4
	>=gnome-extra/at-spi-1.1.6
	>=app-accessibility/gnome-speech-0.2.4
	>=app-accessibility/gnome-mag-0.9
	>=gnome-extra/libgail-gnome-1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_compile() {
	local myconf="--with-default-fonts-path=${D}/usr/share/fonts/default/Type1"

	use ipv6 && myconf="${myconf} --enable-ipv6"
	G2CONF="${G2CONF} ${myconf}"

	gnome2_src_configure
	emake || die "compilation failure"
}
