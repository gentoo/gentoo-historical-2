# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-joystick/xmms-joystick-1.2.10-r1.ebuild,v 1.6 2006/05/23 19:46:01 corsair Exp $

IUSE=""
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 sparc x86"

DEPEND=">=media-sound/xmms-1.2.10"

PLUGIN_PATH="General/joystick"

PATCH_VER="2.2.2"
M4_VER="1.1"

inherit xmms-plugin
