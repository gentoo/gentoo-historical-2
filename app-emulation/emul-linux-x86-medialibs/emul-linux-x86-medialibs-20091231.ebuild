# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-medialibs/emul-linux-x86-medialibs-20091231.ebuild,v 1.3 2010/01/02 14:53:51 ssuominen Exp $

inherit emul-linux-x86

LICENSE="GPL-2 LGPL-2.1 BSD"
KEYWORDS="-* ~amd64"

IUSE=""

DEPEND=""
RDEPEND="~app-emulation/emul-linux-x86-baselibs-${PV}
	~app-emulation/emul-linux-x86-soundlibs-${PV}
	~app-emulation/emul-linux-x86-xlibs-${PV}
	~app-emulation/emul-linux-x86-sdl-${PV}
	!<=app-emulation/emul-linux-x86-sdl-20081109"
