# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-gpm/selinux-gpm-20041128.ebuild,v 1.1.1.1 2005/11/30 10:02:16 chriswhite Exp $

inherit selinux-policy

TEFILES="gpm.te"
FCFILES="gpm.fc"
IUSE=""

DESCRIPTION="SELinux policy for the console mouse server"

KEYWORDS="amd64 ~mips ppc sparc x86"

