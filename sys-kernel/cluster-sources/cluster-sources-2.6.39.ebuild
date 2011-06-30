# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/cluster-sources/cluster-sources-2.6.39.ebuild,v 1.1 2011/06/30 21:41:06 alexxy Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Gentoo patchset + some additional cluster related patches"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches/ http://dev.gentoo.org/~alexxy/cluster/"
IUSE=""

CLUSTER_VERSION="2"

CLUSTER_SRC="clusterpathches-${PV}-${CLUSTER_VERSION}.tar.bz2"

CLUSTER_URI="http://dev.gentoo.org/~alexxy/cluster/${CLUSTER_SRC}"

UNIPATCH_LIST="${DISTDIR}/${CLUSTER_SRC}"
UNIPATCH_STRICTORDER="yes"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CLUSTER_URI}"

KEYWORDS="~amd64 ~x86"

K_SECURITY_UNSUPPORTED="1"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
