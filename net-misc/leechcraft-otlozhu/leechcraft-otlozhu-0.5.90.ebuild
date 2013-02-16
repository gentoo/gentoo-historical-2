# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-otlozhu/leechcraft-otlozhu-0.5.90.ebuild,v 1.2 2013/02/16 21:11:50 ago Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Otlozhu, a GTD-inspired ToDo manager plugin for LeechCraft"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}
	>=x11-libs/qt-gui-4.8:4"
RDEPEND="${DEPEND}"
