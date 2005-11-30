# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/adie/adie-1.5.4.ebuild,v 1.1.1.1 2005/11/30 10:02:05 chriswhite Exp $

inherit fox

DESCRIPTION="Text editor based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~ppc ~ppc64 ~sparc"
IUSE=""

RDEPEND="~x11-libs/fox-${PV}"
