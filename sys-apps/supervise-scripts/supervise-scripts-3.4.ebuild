# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/supervise-scripts/supervise-scripts-3.4.ebuild,v 1.7 2002/10/04 21:28:36 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Starting and stopping daemontools managed services."
SRC_URI="http://untroubled.org/supervise-scripts/${P}.tar.gz"
HOMEPAGE="http://untroubled.org/supervise-scripts/"
KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="GPL-2"
RDEPENDS=">=sys-apps/daemontools-0.70"

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe svc-add svc-isdown svc-isup svc-remove \
				svc-start svc-status svc-stop \
				svc-waitdown svc-waitup svscan-add-to-inittab
}
