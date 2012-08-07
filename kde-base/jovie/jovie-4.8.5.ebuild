# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/jovie/jovie-4.8.5.ebuild,v 1.1 2012/08/07 11:04:41 johu Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"

inherit kde4-base

DESCRIPTION="Jovie is a text to speech application"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-accessibility/speech-dispatcher
"
RDEPEND="${DEPEND}"
