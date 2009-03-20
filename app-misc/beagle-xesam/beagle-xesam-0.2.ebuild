# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/beagle-xesam/beagle-xesam-0.2.ebuild,v 1.1 2009/03/20 18:07:16 ford_prefect Exp $

inherit gnome.org

DESCRIPTION="Xesam search adaptor for Beagle"
HOMEPAGE="http://beagle-project.org/"

LICENSE="MIT Apache-1.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-dotnet/dbus-sharp-0.6.0
		>=dev-dotnet/dbus-glib-sharp-0.4.1"
RDEPEND="${DEPEND}
		>=app-misc/beagle-0.2"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README ISSUES
}
