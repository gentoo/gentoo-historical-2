# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-screen/selinux-screen-20050821.ebuild,v 1.1.1.1 2005/11/30 10:02:16 chriswhite Exp $

inherit selinux-policy

TEFILES="screen.te"
FCFILES="screen.fc"
MACROS="screen_macros.te"
IUSE=""

DESCRIPTION="SELinux policy for GNU Screen"

KEYWORDS="amd64 mips ppc sparc x86"
#KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
