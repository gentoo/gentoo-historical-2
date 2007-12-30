# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/dbus-sharp/dbus-sharp-0.6.0.ebuild,v 1.1 2007/12/30 03:14:17 compnerd Exp $

inherit mono multilib

MY_PN="ndesk-dbus"

DESCRIPTION="Managed D-Bus Implementation for .NET"
HOMEPAGE="http://www.ndesk.org/DBusSharp"
SRC_URI="http://www.ndesk.org/archive/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-lang/mono-1.2.4"
RDEPEND="${DEPEND}
		 >=sys-apps/dbus-1.0"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	econf || die "configure failed"
	emake || die "build failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
