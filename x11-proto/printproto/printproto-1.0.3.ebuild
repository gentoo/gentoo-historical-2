# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/printproto/printproto-1.0.3.ebuild,v 1.10 2006/06/30 22:16:27 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Print protocol headers"
RESTRICT="mirror"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}"
