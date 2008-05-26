# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-runner/twisted-runner-8.0.0.ebuild,v 1.2 2008/05/26 08:19:37 lordvan Exp $

MY_PACKAGE=Runner

inherit twisted versionator

DESCRIPTION="Twisted Runner is a process management library and inetd replacement."

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1)*"

PROVIDE="virtual/inetd"
