# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-mail/twisted-mail-0.3.0.ebuild,v 1.4 2006/08/01 15:19:07 blubb Exp $

MY_PACKAGE=Mail

inherit twisted

DESCRIPTION="A Twisted Mail library, server and client."

KEYWORDS="~alpha amd64 ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-python/twisted-2.4
	>=dev-python/twisted-names-0.2.0"
