# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmouth/kmouth-4.6.5.ebuild,v 1.3 2011/08/15 19:59:23 maekke Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdeaccessibility"
KMMODULE="kmouth"

inherit kde4-meta

DESCRIPTION="KDE application that reads what you type out loud. Doesn't include a speech synthesizer."
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"
