# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-0.5.1.ebuild,v 1.3 2002/02/12 01:23:19 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 2.2

DESCRIPTION="K3b, KDE CD Writing Software"
SRC_URI="http://prdownloads.sourceforge.net/k3b/${P}.tar.gz"
HOMEPAGE="http://k3b.sourceforge.net"
SLOT="0"
newdepend ">=media-sound/mpg123-0.59
	>=media-sound/cdparanoia-3.9.8
	>=app-cdr/cdrtools-1.11
	>=app-cdr/cdrdao-1.1.5
	>=media-libs/id3lib-3.8.0_pre2"
