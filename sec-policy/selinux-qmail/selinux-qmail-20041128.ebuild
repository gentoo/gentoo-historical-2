# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-qmail/selinux-qmail-20041128.ebuild,v 1.1.1.1 2005/11/30 10:02:13 chriswhite Exp $

inherit selinux-policy

TEFILES="qmail.te"
FCFILES="qmail.fc"
IUSE=""

DESCRIPTION="SELinux policy for qmail"

KEYWORDS="x86 ppc sparc amd64"

