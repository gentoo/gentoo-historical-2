# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qtcurve-qt4/qtcurve-qt4-0.55.3.ebuild,v 1.3 2008/02/25 16:30:57 yngwin Exp $

inherit qt4 cmake-utils

MY_P="${P/qtcurve-qt4/QtCurve-KDE4}"
DESCRIPTION="A set of widget styles for Qt4 based apps, also available for KDE3 and GTK2"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=40492"
SRC_URI="http://home.freeuk.com/cpdrummond/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(qt4_min_version 4.0)"

S="${WORKDIR}/${MY_P}"
DOCS="ChangeLog README TODO"
