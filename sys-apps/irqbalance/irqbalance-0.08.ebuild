# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/irqbalance/irqbalance-0.08.ebuild,v 1.3 2004/05/25 05:06:58 mr_bones_ Exp $

S="${WORKDIR}/irqbalance"
DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="http://people.redhat.com/arjanv/irqbalance/"
SRC_URI="http://people.redhat.com/arjanv/irqbalance/${P}.tar.gz"

LICENSE="OSL-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	into /
	dosbin irqbalance || die "dosbin failed"
	doman irqbalance.1
	dodoc Changelog TODO
}

