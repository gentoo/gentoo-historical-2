# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knotify/knotify-4.1.3.ebuild,v 1.1 2008/11/09 02:29:11 scarabeus Exp $

EAPI="2"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="The KDE notification daemon."
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="media-sound/phonon"
RDEPEND="${DEPEND}"
