# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web2/twisted-web2-8.2.0.ebuild,v 1.1 2009/03/08 00:44:48 patrick Exp $

MY_PACKAGE=Web

inherit twisted eutils versionator

DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*"
RDEPEND="${DEPEND}"

IUSE=""
