# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leechcraft-auscrie/leechcraft-auscrie-0.5.90.ebuild,v 1.2 2013/02/16 20:44:12 ago Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Auscrie, LeechCraft auto screenshooter"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"
