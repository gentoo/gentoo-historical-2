# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXcursor/libXcursor-1.1.3-r1.ebuild,v 1.3 2005/08/24 01:06:56 vapier Exp $

# Must be before x-modular eclass is inherited
SNAPSHOT="yes"

inherit x-modular

PATCHES="${FILESDIR}/make-icondir-configurable.patch"

DESCRIPTION="X.Org Xcursor library"
#HOMEPAGE="http://foo.bar.com/"
#SRC_URI="ftp://foo.bar.com/${P}.tar.bz2"
#LICENSE=""
#SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~s390 ~sparc ~x86"
#IUSE="X gnome"
RDEPEND="x11-libs/libXrender
	x11-libs/libXfixes
	x11-libs/libX11"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="--with-icondir=/usr/share/cursors/xorg-x11
	--with-xcursor-path=~/.cursors:~/.icons:/usr/local/share/cursors/xorg-x11:/usr/share/cursors/xorg-x11:/usr/share/pixmaps/xorg-x11"
