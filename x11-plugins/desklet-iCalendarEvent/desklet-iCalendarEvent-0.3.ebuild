# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-iCalendarEvent/desklet-iCalendarEvent-0.3.ebuild,v 1.2 2010/05/08 21:29:07 nixphoeni Exp $

EAPI=2

CONTROL_NAME="${PN#desklet-}"
# This only needs to stick around until the new eclass is committed
DESKLET_NAME="${PN#desklet-}"

inherit gdesklets

DESCRIPTION="iCalendarEvent Control for gDesklets"
HOMEPAGE="http://gdesklets.de/index.php?q=control/view/231"
SRC_URI="${SRC_URI/\/desklets//controls}"
LICENSE="GPL-2"
# KEYWORDS limited by dev-python/icalendar
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-python/icalendar-2.0.1
	>=dev-python/python-dateutil-1.2
	dev-libs/libgamin[python]"
DOCS="Manifest"
