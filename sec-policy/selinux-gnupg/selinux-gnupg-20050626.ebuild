# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-gnupg/selinux-gnupg-20050626.ebuild,v 1.3 2005/09/10 08:14:49 kaiowas Exp $

inherit selinux-policy

TEFILES="gpg.te"
FCFILES="gpg.fc"
MACROS="gpg_macros.te"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for GNU privacy guard"

KEYWORDS="x86 ppc sparc amd64 mips"

