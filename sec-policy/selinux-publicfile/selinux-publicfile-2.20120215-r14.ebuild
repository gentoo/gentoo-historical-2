# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-publicfile/selinux-publicfile-2.20120215-r14.ebuild,v 1.2 2012/07/30 16:26:09 swift Exp $
EAPI="4"

IUSE=""
MODS="publicfile"
BASEPOL="2.20120215-r14"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for publicfile"

KEYWORDS="amd64 x86"
