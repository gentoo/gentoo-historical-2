# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/qemu/qemu-0.9.1.ebuild,v 1.1 2008/01/27 10:27:17 lu_zero Exp $

DESCRIPTION="qemu emulator and abi wrapper meta ebuild"
HOMEPAGE="http://fabrice.bellard.free.fr/qemu/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="~app-emulation/qemu-softmmu-${PV}
		~app-emulation/qemu-user-${PV}
		!<=app-emulation/qemu-0.7.0"
