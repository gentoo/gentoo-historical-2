# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/attica/attica-4.9.3.ebuild,v 1.4 2012/11/30 15:15:05 ago Exp $

EAPI=4

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="Open Collaboration Services provider management"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=dev-libs/libattica-0.1.4
"
RDEPEND="${DEPEND}"
