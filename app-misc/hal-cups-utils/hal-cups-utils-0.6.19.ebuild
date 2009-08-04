# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hal-cups-utils/hal-cups-utils-0.6.19.ebuild,v 1.1 2009/08/04 12:01:41 wired Exp $

EAPI="2"

DESCRIPTION="Hal cups utilities"
HOMEPAGE="https://fedorahosted.org/hal-cups-utils/"
SRC_URI="https://fedorahosted.org/releases/h/a/hal-cups-utils/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.16
	net-print/cups
	>=sys-apps/dbus-1.2
	>=sys-apps/hal-0.5.10
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	app-admin/system-config-printer-common
"

src_install() {
	dodoc AUTHORS ChangeLog README || die "dodoc failed"

	emake DESTDIR="${D}" install || die "emake install failed"
}
