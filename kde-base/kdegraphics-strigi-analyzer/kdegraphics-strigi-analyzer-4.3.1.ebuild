# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegraphics-strigi-analyzer/kdegraphics-strigi-analyzer-4.3.1.ebuild,v 1.3 2009/10/18 15:00:37 maekke Exp $

EAPI="2"

KMNAME="kdegraphics"
KMMODULE="strigi-analyzer"
inherit kde4-meta

DESCRIPTION="kdegraphics: strigi plugins"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug"

KMEXTRACTONLY="libs/mobipocket"
