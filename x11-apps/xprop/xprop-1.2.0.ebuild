# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xprop/xprop-1.2.0.ebuild,v 1.1 2010/11/01 11:55:06 scarabeus Exp $

EAPI=3
XORG_STATIC=no
inherit xorg-2

DESCRIPTION="property displayer for X"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
