# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-gnupg/selinux-gnupg-20050626.ebuild,v 1.1.1.1 2005/11/30 10:02:16 chriswhite Exp $

inherit selinux-policy

TEFILES="gpg.te"
FCFILES="gpg.fc"
MACROS="gpg_macros.te"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for GNU privacy guard"

KEYWORDS="amd64 mips ppc sparc x86"

