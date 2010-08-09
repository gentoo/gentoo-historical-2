# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkipi/libkipi-4.4.5.ebuild,v 1.4 2010/08/09 09:56:22 fauli Exp $

EAPI="3"

KMNAME="kdegraphics"
KMMODULE="libs/${PN}"
inherit kde4-meta

DESCRIPTION="A library for image plugins accross KDE applications."
HOMEPAGE="http://www.kipi-plugins.org"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"
