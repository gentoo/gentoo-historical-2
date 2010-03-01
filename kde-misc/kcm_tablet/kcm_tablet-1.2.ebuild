# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcm_tablet/kcm_tablet-1.2.ebuild,v 1.1 2010/03/01 11:28:48 ssuominen Exp $

EAPI=2
KDE_LINGUAS="de en_GB"
inherit kde4-base

DESCRIPTION="KControl module for wacom tablets"
HOMEPAGE="http://kde-apps.org/content/show.php?action=content&content=114856"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/114856-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="!<x11-drivers/xf86-input-wacom-0.10.3"

DOCS="AUTHORS README"
