# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-opengl-spectrum/xmms-opengl-spectrum-1.2.10.ebuild,v 1.3 2005/03/16 05:57:49 eradicator Exp $

IUSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

DEPEND=">=media-sound/xmms-1.2.10
	virtual/opengl"

PLUGIN_PATH="Visualization/opengl_spectrum"

M4_VER="1.1"

myconf="--enable-opengl"
inherit xmms-plugin
