# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-icecast/selinux-icecast-2.20120725-r8.ebuild,v 1.1 2012/12/03 08:52:30 swift Exp $
EAPI="4"

IUSE=""
MODS="icecast"
BASEPOL="2.20120725-r8"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for icecast"

KEYWORDS="~amd64 ~x86"
