# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp/dbus-sharp-0.7.0.ebuild,v 1.2 2011/06/21 13:36:39 phajdan.jr Exp $

EAPI=4
inherit mono

DESCRIPTION="D-Bus for .NET"
HOMEPAGE="https://github.com/mono/dbus-sharp"
SRC_URI="https://github.com/downloads/mono/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-lang/mono
	sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS README"
}
