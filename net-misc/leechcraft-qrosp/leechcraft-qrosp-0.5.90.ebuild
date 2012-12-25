# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-qrosp/leechcraft-qrosp-0.5.90.ebuild,v 1.1 2012/12/25 16:49:24 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Qrosp, scrpting support for LeechCraft via Qross."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}
	dev-libs/qjson
	dev-libs/qrosscore"
RDEPEND="${DEPEND}"
