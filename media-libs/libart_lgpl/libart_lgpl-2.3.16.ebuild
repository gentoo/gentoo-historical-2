# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libart_lgpl/libart_lgpl-2.3.16.ebuild,v 1.17 2004/10/01 23:18:51 kito Exp $

inherit gnome2

DESCRIPTION="a LGPL version of libart"
HOMEPAGE="http://www.levien.com/libart"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 s390 sparc x86 ~ppc-macos"
IUSE=""

DEPEND="dev-util/pkgconfig"
RDEPEND="virtual/libc"
# Add the RDEPEND so we dont have a runtime dep on pkg-config

DOCS="AUTHORS ChangeLog INSTALL NEWS README"