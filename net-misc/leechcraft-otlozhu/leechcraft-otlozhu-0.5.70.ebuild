# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-otlozhu/leechcraft-otlozhu-0.5.70.ebuild,v 1.2 2012/07/04 21:14:40 ago Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Otlozhu, a GTD-inspired ToDo manager plugin for LeechCraft"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}
	>=x11-libs/qt-gui-4.8"
RDEPEND="${DEPEND}"
