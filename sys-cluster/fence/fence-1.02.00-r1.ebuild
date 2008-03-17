# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/fence/fence-1.02.00-r1.ebuild,v 1.7 2008/03/17 16:38:40 xmerlin Exp $

inherit eutils

CLUSTER_RELEASE="1.02.00"
MY_P="cluster-${CLUSTER_RELEASE}"
CVS_RELEASE="20060713"

DESCRIPTION="I/O fencing system"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz
	mirror://gentoo/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz
	http://dev.gentoo.org/~xmerlin/gfs/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="=sys-cluster/ccs-${CLUSTER_RELEASE}*
	=sys-cluster/cman-headers-${CLUSTER_RELEASE}*
	dev-perl/Net-Telnet
	dev-perl/Net-SSLeay"

RDEPEND="=sys-cluster/ccs-${CLUSTER_RELEASE}*
	dev-perl/Net-Telnet
	dev-perl/Net-SSLeay"

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PN}-${PV}-${CVS_RELEASE}-cvs.patch || die
}

src_compile() {
	./configure || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"

	into /
	dosbin "${FILESDIR}"/${PN}_xen || die

	newinitd "${FILESDIR}"/${PN}d.rc ${PN}d || die
	newconfd "${FILESDIR}"/${PN}d.conf ${PN}d || die
}
