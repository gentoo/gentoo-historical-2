# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/secpolicy/secpolicy-0.0.1.ebuild,v 1.2 2002/05/21 18:14:04 danarmak Exp $


PARENT="kde-base/kdeadmin/kdeadmin-3.0-r1.ebuild"
inherit kde-child

DESCRIPTION="kdeadmin - lilo-config: kcontrol module for lilo configuration"

newdepend "pam? ( >=sys-libs/pam-0.72 )"
use pam	&& myconf="$myconf --with-pam"	|| myconf="$myconf --without-pam --with-shadow"

