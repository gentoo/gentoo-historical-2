# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXfixes/libXfixes-4.0.4.ebuild,v 1.7 2010/01/14 22:40:46 maekke Exp $

inherit x-modular

DESCRIPTION="X.Org Xfixes library"

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	>=x11-proto/fixesproto-4
	x11-proto/xproto"
DEPEND="${RDEPEND}
	x11-proto/xextproto"
