# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-cpplibs/emul-linux-x86-cpplibs-20100409.ebuild,v 1.1 2010/04/09 17:22:58 pacho Exp $

inherit emul-linux-x86

LICENSE="Boost-1.0 LGPL-2.1"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=""
RDEPEND="~app-emulation/emul-linux-x86-baselibs-${PV}"
