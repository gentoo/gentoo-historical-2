# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-snort/selinux-snort-20040412.ebuild,v 1.1 2004/04/12 21:06:48 pebenito Exp $

TEFILES="snort.te"
FCFILES="snort.fc"
IUSE=""

inherit selinux-policy

DESCRIPTION="SELinux policy for snort"

KEYWORDS="x86 ppc sparc"

