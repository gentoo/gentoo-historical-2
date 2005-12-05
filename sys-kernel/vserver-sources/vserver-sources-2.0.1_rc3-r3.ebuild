# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vserver-sources/vserver-sources-2.0.1_rc3-r3.ebuild,v 1.2 2005/12/05 10:47:03 phreak Exp $

ETYPE="sources"
CKV="2.6.14"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="4"

K_USEPV=1
K_NOSETEXTRAVERSION=1

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~amd64 ~x86"
IUSE=""

DESCRIPTION="Full sources including gentoo and Linux-VServer patchsets for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="http://dev.croup.de/proj/gentoo-vps"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	http://dev.gentoo.org/~hollow/distfiles/${PF}.tar.bz2
	http://dev.gentoo.org/~phreak/distfiles/${PF}.tar.bz2"

UNIPATCH_STRICTORDER=1
UNIPATCH_LIST="${DISTDIR}/${PF}.tar.bz2"
