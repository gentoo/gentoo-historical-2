# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-hal/selinux-hal-20070329.ebuild,v 1.2 2007/06/04 00:26:41 pebenito Exp $

IUSE=""

MODS="hal"

inherit selinux-policy-2

RDEPEND="sec-policy/selinux-dbus"

DESCRIPTION="SELinux policy for desktops"

KEYWORDS="alpha amd64 mips ppc sparc x86"
