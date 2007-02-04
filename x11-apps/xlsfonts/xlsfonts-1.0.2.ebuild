# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xlsfonts/xlsfonts-1.0.2.ebuild,v 1.1 2007/02/04 17:02:11 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xlsfonts application"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
