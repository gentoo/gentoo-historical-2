# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/dmxproto/dmxproto-2.3.ebuild,v 1.7 2010/04/16 21:38:53 pacho Exp $

inherit x-modular

DESCRIPTION="X.Org DMX protocol headers"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="!<x11-libs/libdmx-1.0.99.1"
DEPEND="${RDEPEND}"
