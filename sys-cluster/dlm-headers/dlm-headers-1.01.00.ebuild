# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/dlm-headers/dlm-headers-1.01.00.ebuild,v 1.4 2006/03/29 18:47:06 corsair Exp $

inherit eutils linux-mod

MY_P="cluster-${PV}"

DESCRIPTION="General-purpose Distributed Lock Manager headers"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="!<sys-cluster/dlm-kernel-1.01.00"
RDEPEND=""

S="${WORKDIR}/${MY_P}/${PN/headers/kernel}"

src_compile() {
	einfo "No compilation necessary"
}

src_install() {
	insinto /usr/include/cluster
	doins src/dlm.h src/dlm_device.h || die
}
