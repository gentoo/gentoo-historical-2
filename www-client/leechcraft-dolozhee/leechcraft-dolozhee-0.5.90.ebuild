# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/leechcraft-dolozhee/leechcraft-dolozhee-0.5.90.ebuild,v 1.2 2013/02/16 21:14:00 ago Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="An issue reporting client for LeechCraft's issue tracker"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"
