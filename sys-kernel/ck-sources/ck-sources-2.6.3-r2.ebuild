# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.6.3-r2.ebuild,v 1.2 2004/04/12 16:36:22 aliz Exp $

UNIPATCH_LIST="${DISTDIR}/patch-${KV}.bz2"
K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"

K_NOUSENAME="yes"
ETYPE="sources"
inherit kernel-2
detect_version
IUSE=""

DESCRIPTION="Full sources for the Stock Linux kernel Con Kolivas's high performance patchset"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="${KERNEL_URI} http://ck.kolivas.org/patches/2.6/${KV/-ck*/}/${KV}/patch-${KV}.bz2"

KEYWORDS="~x86"

