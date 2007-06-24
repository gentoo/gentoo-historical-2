# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-arghdirector/vdr-arghdirector-0.2.6.ebuild,v 1.4 2007/06/24 13:33:49 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: use the multifeed option of some Premiere channels - fork of vdr-director"
HOMEPAGE="http://www.arghgra.de/arghdirector.html"
SRC_URI="http://www.arghgra.de/vdr-arghdirector-0.2.6.tar.gz
		mirror://vdrfiles/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""


DEPEND=">=media-video/vdr-1.3.34"

PATCHES="${FILESDIR}/${P}-vdr-1.5.3.diff"

