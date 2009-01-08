# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted-web/twisted-web-8.1.0.ebuild,v 1.9 2009/01/08 22:38:37 patrick Exp $

MY_PACKAGE=Web

inherit twisted eutils versionator

DESCRIPTION="Twisted web server, programmable in Python"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

DEPEND="=dev-python/twisted-$(get_version_component_range 1-2)*"

IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.5.0-root-skip.patch
}
