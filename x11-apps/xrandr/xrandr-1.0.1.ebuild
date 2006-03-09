# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xrandr/xrandr-1.0.1.ebuild,v 1.6 2006/03/09 14:00:01 agriffis Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xrandr application"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
RDEPEND="x11-libs/libXrandr
	x11-libs/libX11"
DEPEND="${RDEPEND}"
