# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-mutt/selinux-mutt-2.20140311-r3.ebuild,v 1.1 2014/05/29 18:57:57 swift Exp $
EAPI="5"

IUSE=""
MODS="mutt"
BASEPOL="2.20140311-r3"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for mutt"

KEYWORDS="~amd64 ~x86"
