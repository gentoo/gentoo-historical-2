# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-asterisk/selinux-asterisk-20050219.ebuild,v 1.1.1.1 2005/11/30 10:02:14 chriswhite Exp $

inherit selinux-policy

TEFILES="asterisk.te"
FCFILES="asterisk.fc"
IUSE=""

DESCRIPTION="Gentoo SELinux policy for asterisk, a modular open-source PBX system"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

