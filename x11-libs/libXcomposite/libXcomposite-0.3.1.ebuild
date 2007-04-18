# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXcomposite/libXcomposite-0.3.1.ebuild,v 1.6 2007/04/18 13:04:47 armin76 Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Xcomposite library"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~mips ~ppc ppc64 ~sh sparc x86 ~x86-fbsd"
RDEPEND="x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXext
	>=x11-proto/compositeproto-0.3
	x11-proto/xproto"
DEPEND="${RDEPEND}"
