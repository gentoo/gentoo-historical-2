# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/irqbalance/irqbalance-0.08-r1.ebuild,v 1.3 2006/10/04 15:24:52 blubb Exp $

DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="http://people.redhat.com/arjanv/irqbalance/"
SRC_URI="http://people.redhat.com/arjanv/irqbalance/${P}.tar.gz"

LICENSE="OSL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/libc"

S="${WORKDIR}/irqbalance"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	into /
	dosbin irqbalance || die "dosbin failed"
	doman irqbalance.1
	dodoc Changelog TODO

	# Give irqbalance an init script
	newinitd "${FILESDIR}/irqbalance-nopid.init" irqbalance
}

pkg_postinst() {
	einfo "irqbalance now has an init script"
	einfo "   rc-update add irqbalance default"
}
