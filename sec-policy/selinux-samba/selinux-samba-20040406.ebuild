# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-samba/selinux-samba-20040406.ebuild,v 1.3 2004/06/28 00:10:37 pebenito Exp $

TEFILES="samba.te"
FCFILES="samba.fc"
IUSE=""

inherit selinux-policy

DESCRIPTION="SELinux policy for samba"

KEYWORDS="x86 ppc sparc"

