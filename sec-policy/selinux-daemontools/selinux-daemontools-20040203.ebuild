# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-daemontools/selinux-daemontools-20040203.ebuild,v 1.4 2004/06/28 00:10:37 pebenito Exp $

TEFILES="daemontools.te"
FCFILES="daemontools.fc"
MACROS="daemontools_macros.te"
IUSE=""

inherit selinux-policy

DESCRIPTION="SELinux policy for daemontools"

KEYWORDS="x86 ppc sparc"

