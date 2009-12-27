# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xmag/xmag-1.0.3.ebuild,v 1.5 2009/12/27 17:49:50 josejx Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xmag application"

KEYWORDS="amd64 ~arm ~hppa ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}"
