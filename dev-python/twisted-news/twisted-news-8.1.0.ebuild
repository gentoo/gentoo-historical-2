# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-news/twisted-news-8.1.0.ebuild,v 1.1 2008/05/25 20:28:18 lordvan Exp $

MY_PACKAGE=News

inherit twisted versionator

DESCRIPTION="Twisted News is an NNTP server and programming library."

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*
	dev-python/twisted-mail"
