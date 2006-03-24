# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/dlm/dlm-1.01.00.ebuild,v 1.2 2006/03/24 19:04:43 agriffis Exp $

MY_P="cluster-${PV}"

DESCRIPTION="General-purpose Distributed Lock Manager"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

IUSE=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"

DEPEND=">=sys-cluster/dlm-headers-1.01.00"
RDEPEND=""

S="${WORKDIR}/${MY_P}/${PN}"

src_compile() {
	./configure || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	newinitd ${FILESDIR}/${PN}.rc ${PN} || die

	dodoc doc/*.txt
}
