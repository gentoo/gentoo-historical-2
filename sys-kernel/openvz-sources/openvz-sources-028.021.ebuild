# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/openvz-sources/openvz-sources-028.021.ebuild,v 1.1 2007/03/14 17:02:48 phreak Exp $

ETYPE="sources"
CKV="2.6.18"

K_USEPV=1
K_NOSETEXTRAVERSION=1

inherit kernel-2
detect_version

OVZ_KERNEL="${PV%%.*}stab${PV##*.}"
OVZ_REV="1"

KEYWORDS="~amd64 ~ia64 ~ppc64 ~sparc ~x86"
IUSE=""

DESCRIPTION="Full sources including OpenVZ patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="http://www.openvz.org"
SRC_URI="${KERNEL_URI} ${ARCH_URI}
	mirror://openvz/kernel/rhel5/${OVZ_KERNEL}.${OVZ_REV}/patches/patch-8.el5.${OVZ_KERNEL}.${OVZ_REV}-combined.gz"

UNIPATCH_STRICTORDER=1
UNIPATCH_LIST="${DISTDIR}/patch-8.el5.${OVZ_KERNEL}.${OVZ_REV}-combined.gz"
