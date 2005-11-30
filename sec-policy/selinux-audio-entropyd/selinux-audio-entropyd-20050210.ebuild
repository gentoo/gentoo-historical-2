# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-audio-entropyd/selinux-audio-entropyd-20050210.ebuild,v 1.1.1.1 2005/11/30 10:02:15 chriswhite Exp $

inherit selinux-policy

TEFILES="audio-entropyd.te"
FCFILES="audio-entropyd.fc"
IUSE=""

DESCRIPTION="SELinux policy for audio-entropyd"

KEYWORDS="x86 ppc sparc amd64"

