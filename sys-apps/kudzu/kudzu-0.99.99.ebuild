# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kudzu/kudzu-0.99.99.ebuild,v 1.5 2004/05/30 14:46:28 wolf31o2 Exp $

DESCRIPTION="Red Hat Hardware detection tools"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.knopper.net"

KEYWORDS="x86 amd64 -ppc -sparc alpha -mips"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="dev-libs/newt"
DEPEND="$RDEPEND sys-apps/pciutils >=dev-libs/dietlibc-0.20"

src_compile() {
	emake  || die

	if [ "${ARCH} = "x86" -o "${ARCH} = "ppc" ]
	then
		cd ddcprobe || die
		emake || die
	fi
}

src_install() {
	einstall install-program DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man || die "Install failed"
	if [ "${ARCH} = "x86" -o "${ARCH} = "ppc" ]
	then
		cd ${S}/ddcprobe || die
		dosbin svgamodes modetest ddcxinfo ddcprobe || die
	fi
}

