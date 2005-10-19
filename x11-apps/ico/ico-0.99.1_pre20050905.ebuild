# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/ico/ico-0.99.1_pre20050905.ebuild,v 1.3 2005/10/19 03:00:43 geoman Exp $

inherit versionator

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

# Fix ${S} in x-modular for pre ebuilds
MY_P="${PN}-$(get_version_component_range 1-3)"
S="${WORKDIR}/${MY_P}"

inherit x-modular

DESCRIPTION="X.Org ico application"
KEYWORDS="~arm ~mips ~s390 ~sparc ~x86"
RDEPEND=">=x11-libs/libX11-0.99.1_pre0"
DEPEND="${RDEPEND}"

# Snapshots don't reside on fdo servers
SRC_URI="mirror://gentoo/${P}.tar.bz2"
