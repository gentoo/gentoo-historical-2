# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xpr/xpr-1.0.2.ebuild,v 1.10 2009/05/28 17:11:12 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xpr application"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd"
IUSE=""
RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"
