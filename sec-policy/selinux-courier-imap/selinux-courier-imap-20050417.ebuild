# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-courier-imap/selinux-courier-imap-20050417.ebuild,v 1.1 2005/04/16 20:42:30 kaiowas Exp $

inherit selinux-policy

TEFILES="courier-imap.te"
FCFILES="courier-imap.fc"
IUSE=""

DESCRIPTION="SELinux policy for courier-imap"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

