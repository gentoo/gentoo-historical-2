# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/gnbd/gnbd-1.03.00.ebuild,v 1.6 2008/03/17 16:59:56 xmerlin Exp $

CLUSTER_RELEASE="1.03.00"
MY_P="cluster-${CLUSTER_RELEASE}"

DESCRIPTION="GFS Network Block Devices"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="=sys-cluster/magma-${CLUSTER_RELEASE}*
	=sys-cluster/gnbd-headers-${CLUSTER_RELEASE}*
	<sys-fs/sysfsutils-2.0.0"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${PN}"

src_compile() {
	./configure || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"

	newinitd "${FILESDIR}"/${PN}-client-1.0x.rc ${PN}-client || die
	newinitd "${FILESDIR}"/${PN}-srv-1.0x.rc ${PN}-srv || die

	doconfd "${FILESDIR}"/${PN}-client-1.0x.conf || die
	doconfd "${FILESDIR}"/${PN}-srv-1.0x.conf || die

	insinto /etc
	doins "${FILESDIR}"/gnbdtab

	if $(has_version sys-fs/devfsd ) ; then
		insinto /etc/devfs.d/
		newins "${FILESDIR}"/gnbd.devfs gnbd
	fi
}
