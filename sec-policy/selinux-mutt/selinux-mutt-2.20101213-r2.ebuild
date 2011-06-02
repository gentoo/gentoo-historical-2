# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-mutt/selinux-mutt-2.20101213-r2.ebuild,v 1.2 2011/06/02 12:38:41 blueness Exp $

IUSE=""

MODS="mutt"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for general applications"

KEYWORDS="amd64 x86"

POLICY_PATCH="${FILESDIR}/add-apps-mutt-r2.patch"
