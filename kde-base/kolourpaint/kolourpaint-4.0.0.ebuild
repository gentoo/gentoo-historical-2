# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kolourpaint/kolourpaint-4.0.0.ebuild,v 1.1 2008/01/18 00:06:21 ingmar Exp $

EAPI="1"

KMNAME=kdegraphics
inherit kde4-meta eutils

DESCRIPTION="Paint Program for KDE"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"
LICENSE="BSD"

DEPEND="kde-base/qimageblitz"
RDEPEND="${DEPEND}"
