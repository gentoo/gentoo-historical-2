# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vanilla-sources/vanilla-sources-2.4.22.ebuild,v 1.14 2005/01/10 21:49:34 dsd Exp $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for the Linux kernel"
HOMEPAGE="http://www.kernel.org"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${PV}.tar.bz2"

KEYWORDS="x86 -ppc sparc alpha amd64"
IUSE=""

UNIPATCH_LIST="${FILESDIR}/do_brk_fix.patch"
