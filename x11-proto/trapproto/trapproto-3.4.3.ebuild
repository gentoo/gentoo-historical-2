# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/trapproto/trapproto-3.4.3.ebuild,v 1.14 2006/07/19 12:41:40 gmsoft Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Trap protocol headers"
RESTRICT="mirror"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}"
