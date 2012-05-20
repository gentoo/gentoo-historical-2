# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-db/emul-linux-x86-db-20120520.ebuild,v 1.1 2012/05/20 13:00:16 pacho Exp $

EAPI="4"

inherit emul-linux-x86

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND="~app-emulation/emul-linux-x86-baselibs-${PV}"
