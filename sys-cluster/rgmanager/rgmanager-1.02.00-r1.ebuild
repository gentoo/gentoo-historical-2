# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/rgmanager/rgmanager-1.02.00-r1.ebuild,v 1.4 2006/10/15 13:50:05 xmerlin Exp $

inherit eutils

CVS_RELEASE="20060713"
MY_P="cluster-${PV}"

DESCRIPTION="Clustered resource group manager layered on top of Magma"
HOMEPAGE="http://sources.redhat.com/cluster/"
SRC_URI="ftp://sources.redhat.com/pub/cluster/releases/${MY_P}.tar.gz
	mirror://gentoo/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz
	http://dev.gentoo.org/~xmerlin/gfs/${PN}-${PV}-${CVS_RELEASE}-cvs.patch.gz"

IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND=">=sys-cluster/magma-1.02.00-r1
	>=sys-cluster/magma-plugins-1.02.00-r1
	dev-libs/libxml2
	"

S="${WORKDIR}/${MY_P}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PN}-${PV}-${CVS_RELEASE}-cvs.patch || die
	epatch ${FILESDIR}/${PN}-${PV}-${CVS_RELEASE}-cvs-clunfslock.patch || die
}

src_compile() {
	./configure || die "configure problem"
	emake || die "compile problem"
}

src_install() {
	emake DESTDIR=${D} install || die "install problem"

	newinitd ${FILESDIR}/${PN}.rc ${PN} || die
	newconfd ${FILESDIR}/${PN}.conf ${PN} || die
}
