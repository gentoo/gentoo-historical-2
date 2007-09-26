# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xen-sources/xen-sources-2.6.20-r4.ebuild,v 1.1 2007/09/26 21:18:03 marineam Exp $

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="18"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://www.xensource.com/xen/xen/"

KEYWORDS="~x86 ~amd64"

XENPATCHES_VER="2"
XENPATCHES="xen-patches-${PV}-${XENPATCHES_VER}.tar.bz2"
XENPATCHES_URI="mirror://gentoo/${XENPATCHES}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${XENPATCHES_URI}"

UNIPATCH_LIST="${DISTDIR}/${XENPATCHES}"

DEPEND="${DEPEND} >=sys-devel/binutils-2.17"
