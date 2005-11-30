# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ucspi-tcp/selinux-ucspi-tcp-20050507.ebuild,v 1.1.1.1 2005/11/30 10:02:15 chriswhite Exp $

inherit selinux-policy

TEFILES="ucspi-tcp.te"
FCFILES="ucspi-tcp.fc"
IUSE=""

DESCRIPTION="SELinux policy for ucspi-tcp"

KEYWORDS="amd64 mips ppc sparc x86"

