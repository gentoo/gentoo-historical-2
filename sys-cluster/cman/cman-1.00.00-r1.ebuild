# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/cman/cman-1.00.00-r1.ebuild,v 1.1 2005/09/05 02:36:00 xmerlin Exp $

CLUSTER_VERSION="1.00.00"
DESCRIPTION="general-purpose symmetric cluster manager"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/cluster-${CLUSTER_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=sys-cluster/ccs-${CLUSTER_VERSION}
	>=sys-cluster/cman-headers-${CLUSTER_VERSION}"

RDEPEND="virtual/libc"


S="${WORKDIR}/cluster-${CLUSTER_VERSION}/${PN}"

src_compile() {
	./configure || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	newinitd ${FILESDIR}/${PN}.rc ${PN} || die
	newconfd ${FILESDIR}/${PN}.conf ${PN} || die
}
