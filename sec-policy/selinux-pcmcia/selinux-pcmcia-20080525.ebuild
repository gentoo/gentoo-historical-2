# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-pcmcia/selinux-pcmcia-20080525.ebuild,v 1.2 2009/07/22 13:12:29 pebenito Exp $

IUSE=""

MODS="pcmcia"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for PCMCIA card services"

KEYWORDS="~amd64 ~x86"
