# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/development-sources/development-sources-2.6.8.ebuild,v 1.3 2004/10/22 14:45:14 pvdabeel Exp $

K_NOUSENAME="yes"
ETYPE="sources"
inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Full sources for the vanilla 2.6 kernel tree"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="${KERNEL_URI} ${ARCH_URI}"
UNIPATCH_LIST="${ARCH_PATCH}"

KEYWORDS="~x86 ~ia64 ppc ~amd64"
IUSE=""
