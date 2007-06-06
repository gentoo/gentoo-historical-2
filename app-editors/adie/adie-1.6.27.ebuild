# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/adie/adie-1.6.27.ebuild,v 1.1 2007/06/06 09:58:22 mabi Exp $

inherit fox

DESCRIPTION="Text editor based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~ppc ~ppc64 ~sparc"
IUSE=""

DEPEND="~x11-libs/fox-${PV}"

RDEPEND="${DEPEND}"
