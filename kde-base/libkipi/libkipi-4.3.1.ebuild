# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkipi/libkipi-4.3.1.ebuild,v 1.3 2009/10/18 15:40:24 maekke Exp $

EAPI="2"

KMNAME="kdegraphics"
KMMODULE="libs/${PN}"
inherit kde4-meta

DESCRIPTION="A library for image plugins accross KDE applications."
HOMEPAGE="http://www.kipi-plugins.org"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug"
