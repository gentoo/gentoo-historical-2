# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkonq/libkonq-4.2.3.ebuild,v 1.1 2009/05/07 00:10:54 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-apps"
KMMODULE="lib/konq"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug"
RESTRICT="test"

KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/fix_includes_install.patch" )
