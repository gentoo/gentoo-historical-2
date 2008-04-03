# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kappfinder/kappfinder-4.0.3.ebuild,v 1.1 2008/04/03 20:39:47 philantrop Exp $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4-meta

DESCRIPTION="KDE tool that looks for well-known apps in your path and creates entries for them in the KDE menu"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND=""
RDEPEND="${DEPEND}"

KMEXTRA="apps/doc/${PN}"
