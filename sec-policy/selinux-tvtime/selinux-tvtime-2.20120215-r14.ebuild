# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-tvtime/selinux-tvtime-2.20120215-r14.ebuild,v 1.1 2012/07/17 14:27:32 swift Exp $
EAPI="4"

IUSE=""
MODS="tvtime"
BASEPOL="2.20120215-r14"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for tvtime"

KEYWORDS="~amd64 ~x86"
