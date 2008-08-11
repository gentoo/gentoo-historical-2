# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-names/twisted-names-8.1.0.ebuild,v 1.3 2008/08/11 18:23:58 fmccor Exp $

MY_PACKAGE=Names

inherit twisted versionator

DESCRIPTION="A Twisted DNS implementation"

KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*"
