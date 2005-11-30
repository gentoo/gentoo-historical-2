# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-publicfile/selinux-publicfile-20041121.ebuild,v 1.1.1.1 2005/11/30 10:02:16 chriswhite Exp $

inherit selinux-policy

TEFILES="publicfile.te"
FCFILES="publicfile.fc"
IUSE=""

RDEPEND="sec-policy/selinux-ucspi-tcp"

DESCRIPTION="SELinux policy for publicfile"

KEYWORDS="x86 ppc sparc amd64"

