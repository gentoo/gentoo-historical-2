# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-meta-pkg.eclass,v 1.9 2012/10/13 22:54:37 johu Exp $

# @ECLASS: kde4-meta-pkg.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass contains boilerplate for kde 4.X meta packages
# @DESCRIPTION:
# This eclass should only be used for defining meta packages for KDE4.

inherit kde4-functions

HOMEPAGE="http://www.kde.org/"

LICENSE="metapackage"
IUSE="aqua"

# Only add the kdeprefix USE flag for older versions, to help
# non-portage package managers handle the upgrade
if [[ ${PV} < 4.6.4 && ( ${PN} != kdepim-meta || ${PV} < 4.6 ) ]]; then
	IUSE+=" kdeprefix"
fi

SLOT=4
