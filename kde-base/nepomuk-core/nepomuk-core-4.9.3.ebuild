# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nepomuk-core/nepomuk-core-4.9.3.ebuild,v 1.3 2012/11/23 19:29:43 ago Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="Nepomuk core libraries"
KEYWORDS="amd64 ~arm x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=app-misc/strigi-0.7.7[dbus,qt4]
	>=dev-libs/soprano-2.8.0[dbus,raptor,redland,virtuoso]
"
RDEPEND="${DEPEND}"

add_blocker nepomuk '<4.8.80'

RESTRICT="test"
# bug 392989
