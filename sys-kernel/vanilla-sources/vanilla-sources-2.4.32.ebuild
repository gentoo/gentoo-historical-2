# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vanilla-sources/vanilla-sources-2.4.32.ebuild,v 1.2 2005/12/16 19:39:51 gustavoz Exp $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
ETYPE="sources"
inherit kernel-2
detect_version

HOMEPAGE="http://www.kernel.org"
SRC_URI="${KERNEL_URI}"
KEYWORDS="~alpha ~amd64 sparc ~x86"
