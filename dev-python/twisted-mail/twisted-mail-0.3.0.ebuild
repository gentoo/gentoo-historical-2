# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-mail/twisted-mail-0.3.0.ebuild,v 1.1 2006/05/26 18:44:19 marienz Exp $

MY_PACKAGE=Mail

inherit twisted

DESCRIPTION="A Twisted Mail library, server and client."

KEYWORDS="~alpha ~ia64 ~ppc ~sparc ~x86"

DEPEND=">=dev-python/twisted-2.4
	>=dev-python/twisted-names-0.2.0"
