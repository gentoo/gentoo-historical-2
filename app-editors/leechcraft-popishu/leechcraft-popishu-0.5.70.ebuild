# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/leechcraft-popishu/leechcraft-popishu-0.5.70.ebuild,v 1.3 2012/07/07 10:23:02 johu Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="Popishu, the text editor with IDE features for LeechCraft."

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="~net-misc/leechcraft-core-${PV}
	x11-libs/qscintilla"
RDEPEND="${DEPEND}"
