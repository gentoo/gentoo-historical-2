# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-test-sources/gentoo-test-sources-2.4.22-r3.ebuild,v 1.2 2004/04/12 16:36:22 aliz Exp $

UNIPATCH_LIST="${DISTDIR}/gentoo-sources-${PVR}.patch.bz2"
ETYPE="sources"
IUSE=""
inherit kernel-2
detect_version

#RESTRICT="nomirror"

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Gentoo Kernel."
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	http://dev.gentoo.org/~iggy/gentoo-test-sources-${PVR}.patch.bz2"
KEYWORDS="~x86 ~amd64 ~ia64 -*"
SLOT="${KV}"

K_EXTRAEINFO="If there are issues with this kernel, search http://bugs.gentoo.org/ for an
existing bug. Only create a new bug if you have not found one that matches
your issue. It is best to do an advanced search as the initial search has a
very low yield. Please assign your bugs to x86-kernel@gentoo.org.
Please read the ChangeLog and associated docs for more information."

