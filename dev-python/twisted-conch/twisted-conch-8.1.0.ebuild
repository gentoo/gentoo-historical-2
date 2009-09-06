# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-conch/twisted-conch-8.1.0.ebuild,v 1.12 2009/09/06 21:02:31 idl0r Exp $

MY_PACKAGE=Conch

inherit twisted eutils versionator

DESCRIPTION="Twisted SSHv2 implementation."

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*
	>=dev-python/pycrypto-1.9_alpha6"
RDEPEND="${DEPEND}"

IUSE=""
