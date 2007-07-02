# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/xorg-docs/xorg-docs-1.4.ebuild,v 1.11 2007/07/02 14:23:13 armin76 Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org docs"

KEYWORDS="alpha amd64 arm hppa ia64 mips ~ppc ppc64 s390 sh ~sparc x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	>=x11-misc/util-macros-1.1.5"
#	>=app-doc/xorg-sgml-doctools-1.2"

IUSE="doc"

PATCHES="${FILESDIR}/1.1-allow_manpages_only.patch"

CONFIGURE_OPTIONS="--with-x11docdir=/usr/share/doc/${PF}
	$(use_enable doc non-man-docs)
	--disable-txt
	--disable-pdf
	--disable-html
	--disable-ps"
#	$(use_enable doc txt)"
#	$(use_enable doc pdf)
#	$(use_enable doc html)
#	$(use_enable doc ps)"
