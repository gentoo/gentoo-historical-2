# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-samba/selinux-samba-20041117.ebuild,v 1.3 2007/07/11 02:56:48 mr_bones_ Exp $

inherit selinux-policy

TEFILES="samba.te"
FCFILES="samba.fc"
IUSE=""

DESCRIPTION="SELinux policy for samba"

KEYWORDS="x86 ppc sparc amd64"
