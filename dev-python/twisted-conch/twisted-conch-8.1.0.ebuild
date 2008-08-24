# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-conch/twisted-conch-8.1.0.ebuild,v 1.5 2008/08/24 11:26:02 corsair Exp $

MY_PACKAGE=Conch

inherit twisted eutils versionator

DESCRIPTION="Twisted SSHv2 implementation."

KEYWORDS="alpha amd64 ia64 ~ppc ppc64 sparc x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*
	>=dev-python/pycrypto-1.9_alpha6"
