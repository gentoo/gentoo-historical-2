# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-daemontools/selinux-daemontools-20041111.ebuild,v 1.1 2004/11/13 19:40:14 kaiowas Exp $

inherit selinux-policy

TEFILES="daemontools.te"
FCFILES="daemontools.fc"
MACROS="daemontools_macros.te"
IUSE=""

DESCRIPTION="SELinux policy for daemontools"

KEYWORDS="x86 ppc sparc amd64"

