# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/fence/fence-1.00.00-r1.ebuild,v 1.1.1.1 2005/11/30 10:01:41 chriswhite Exp $

MY_P="cluster-${PV}"

DESCRIPTION="I/O fencing system"
HOMEPAGE="http://sources.redhat.com/cluster/"

SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=sys-cluster/ccs-1.00.00
	>=sys-cluster/cman-headers-1.00.00"


S="${WORKDIR}/${MY_P}/${PN}"

src_compile() {
	./configure || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	newinitd ${FILESDIR}/${PN}d.rc ${PN}d || die
	newconfd ${FILESDIR}/${PN}d.conf ${PN}d || die
}
