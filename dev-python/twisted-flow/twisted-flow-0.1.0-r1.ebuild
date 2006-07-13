# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-flow/twisted-flow-0.1.0-r1.ebuild,v 1.9 2006/07/13 02:27:47 agriffis Exp $

MY_PACKAGE=Flow

inherit twisted

DESCRIPTION="A Twisted concurrency programming library."

KEYWORDS="amd64 ia64 ~ppc sparc x86"

DEPEND=">=dev-python/twisted-2
	<dev-python/twisted-2.4"
