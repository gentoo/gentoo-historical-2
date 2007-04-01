# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpthread-stubs/libpthread-stubs-0.1.ebuild,v 1.4 2007/04/01 08:07:01 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Pthread functions stubs for platforms missing them"
SRC_URI="http://xcb.freedesktop.org/dist/${P}.tar.bz2"

KEYWORDS="~alpha ~amd64 arm ~hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
LICENSE="X11"

RDEPEND=""
DEPEND=""
