# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-arch/kpackage/kpackage-3.0.ebuild,v 1.2 2002/05/21 18:14:04 danarmak Exp $


PARENT="kde-base/kdeadmin/kdeadmin-3.0-r1.ebuild"
inherit kde-child

DESCRIPTION="kdeadmin - kpackage: frontend for managing rpms, debs etc."

newdepend ">=app-arch/rpm-3.0.5"
myconf="$myconf --with-rpm"
