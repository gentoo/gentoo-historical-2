# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-0.6.0_pre2.ebuild,v 1.1 2002/04/02 14:05:37 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 3

S="${WORKDIR}/k3b-0.6.0pre2"
DESCRIPTION="K3b, KDE CD Writing Software"
SRC_URI="http://prdownloads.sourceforge.net/k3b/k3b-0.6.0pre2.tar.gz"
HOMEPAGE="http://k3b.sourceforge.net"
SLOT="0"
newdepend ">=media-sound/mpg123-0.59
	>=media-sound/cdparanoia-3.9.8
	>=app-cdr/cdrtools-1.11
	>=app-cdr/cdrdao-1.1.5
	>=media-libs/id3lib-3.8.0_pre2
	>=media-sound/mad-0.14.2b-r1"
