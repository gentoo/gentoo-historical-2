# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ftpd/selinux-ftpd-20050626.ebuild,v 1.2 2005/06/26 17:02:12 kaiowas Exp $

inherit selinux-policy

TEFILES="ftpd.te"
FCFILES="ftpd.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for ftp daemons"

KEYWORDS="x86 ppc sparc amd64"

