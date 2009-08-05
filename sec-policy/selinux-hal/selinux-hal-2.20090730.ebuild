# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-hal/selinux-hal-2.20090730.ebuild,v 1.1 2009/08/05 13:35:13 pebenito Exp $

IUSE=""

MODS="hal dmidecode"

inherit selinux-policy-2

RDEPEND="sec-policy/selinux-dbus"

DESCRIPTION="SELinux policy for desktops"

KEYWORDS="~amd64 ~x86"
