# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-names/twisted-names-0.1.0-r1.ebuild,v 1.6 2006/05/26 17:40:35 marienz Exp $

MY_PACKAGE=Names

inherit twisted

DESCRIPTION="A Twisted DNS implementation."

KEYWORDS="~amd64 ~ppc sparc x86"

DEPEND=">=dev-python/twisted-2
	<dev-python/twisted-2.4"
