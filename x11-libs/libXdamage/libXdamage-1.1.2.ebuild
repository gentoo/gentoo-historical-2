# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXdamage/libXdamage-1.1.2.ebuild,v 1.9 2010/01/18 19:50:28 armin76 Exp $

inherit x-modular

DESCRIPTION="X.Org Xdamage library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXfixes
	>=x11-proto/damageproto-1.1
	x11-proto/xproto"
DEPEND="${RDEPEND}"
