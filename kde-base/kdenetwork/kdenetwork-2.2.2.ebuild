# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork/kdenetwork-2.2.2.ebuild,v 1.3 2002/01/17 18:59:47 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-dist || die

DESCRIPTION="${DESCRIPTION}Network"

src_unpack() {

    base_src_unpack
    kde_sandbox_patch ${S}/kppp

}