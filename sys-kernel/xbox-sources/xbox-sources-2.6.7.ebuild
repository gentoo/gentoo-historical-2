# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xbox-sources/xbox-sources-2.6.7.ebuild,v 1.1 2004/06/30 01:26:07 chrb Exp $

ETYPE="sources"
inherit kernel-2
detect_version

#version of gentoo patchset
XPV=7.20040629
XBOX_PATCHES=xboxpatches-${KV_MAJOR}.${KV_MINOR}-${XPV}.tar.bz2

K_NOSETEXTRAVERSION="don't_set_it"
KEYWORDS="~x86 -*"
UNIPATCH_LIST="${DISTDIR}/${XBOX_PATCHES}"
DESCRIPTION="Full sources for the Xbox Linux kernel"
SRC_URI="${KERNEL_URI}
	mirror://gentoo/${XBOX_PATCHES}"
