# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/system-config-printer-kde/system-config-printer-kde-4.3.3.ebuild,v 1.1 2009/11/02 22:14:33 wired Exp $

EAPI="2"

KMNAME="kdeadmin"
inherit kde4-meta python

DESCRIPTION="KDE port of Red Hat's Gnome system-config-printer"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~x86"
IUSE=""

DEPEND="
	>=app-admin/system-config-printer-common-1.1.12
	>=dev-python/pycups-1.9.46
	$(add_kdebase_dep pykde4)
"
RDEPEND="${DEPEND}
	net-print/cups[dbus]
"
