# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xcompmgr/xcompmgr-1.1.4.ebuild,v 1.2 2008/10/14 12:21:42 flameeyes Exp $

inherit x-modular

DESCRIPTION="X Compositing manager"
HOMEPAGE="http://freedesktop.org/Software/xapps"
SRC_URI="http://xorg.freedesktop.org/releases/individual/app/${P}.tar.bz2"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND="x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite"
DEPEND="${RDEPEND}"