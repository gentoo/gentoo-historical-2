# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-nordlichtsepg/vdr-nordlichtsepg-0.4.ebuild,v 1.2 2006/02/06 23:05:52 zzam Exp $

inherit vdr-plugin

IUSE=""
SLOT="0"

DESCRIPTION="vdr Plugin: Better EPG view than default vdr"
HOMEPAGE="http://martins-kabuff.de/nordlichtsepg.html"
SRC_URI="http://martins-kabuff.de/download/${P}.tgz"
LICENSE="GPL-2"

KEYWORDS="x86"

DEPEND=">=media-video/vdr-1.3.31"
