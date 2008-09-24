# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xrefresh/xrefresh-1.0.2.ebuild,v 1.7 2008/09/24 10:35:01 aballier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="refresh all or part of an X screen"
KEYWORDS="amd64 arm ~mips ~ppc ~ppc64 s390 sh ~sparc x86 ~x86-fbsd"
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
