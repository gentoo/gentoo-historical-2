# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-headers/linux-headers-2.4.26-r1.ebuild,v 1.4 2005/07/16 01:29:13 vapier Exp $

ETYPE="headers"
H_SUPPORTEDARCH="arm m68k sparc"
inherit eutils kernel-2
detect_version

SRC_URI="${KERNEL_URI}"
KEYWORDS="-* arm m68k ~sparc"

UNIPATCH_LIST=""
