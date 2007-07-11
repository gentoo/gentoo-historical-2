# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ftpd/selinux-ftpd-20050903.ebuild,v 1.3 2007/07/11 02:56:47 mr_bones_ Exp $

inherit selinux-policy

TEFILES="ftpd.te"
FCFILES="ftpd.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for ftp daemons"

KEYWORDS="amd64 mips ppc sparc x86"
