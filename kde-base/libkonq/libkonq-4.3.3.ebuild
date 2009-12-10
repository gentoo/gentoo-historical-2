# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkonq/libkonq-4.3.3.ebuild,v 1.5 2009/12/10 17:26:11 fauli Exp $

EAPI="2"

KMNAME="kdebase-apps"
KMMODULE="lib/konq"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="debug"
RESTRICT="test"

KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/fix_includes_install.patch" )
