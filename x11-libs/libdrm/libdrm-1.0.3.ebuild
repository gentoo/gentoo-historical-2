# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libdrm/libdrm-1.0.3.ebuild,v 1.2 2005/08/20 22:51:54 lu_zero Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="http://dri.freedesktop.org/"
SRC_URI="http://xorg.freedesktop.org/extras/${P}.tar.gz"
#LICENSE=""
#SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
RDEPEND=""
DEPEND="${RDEPEND}"
