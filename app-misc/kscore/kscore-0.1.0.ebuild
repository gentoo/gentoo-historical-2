# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-misc/kscore/kscore-0.1.0.ebuild,v 1.1 2002/05/10 12:07:56 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die

PARENT="kde-base/kdetoys/kdetoys-3.0-r1.ebuild"
FORCE=kscore
inherit kde-child

DESCRIPTION="kdetoys - kscore: kicker applet with a sports ticker"

