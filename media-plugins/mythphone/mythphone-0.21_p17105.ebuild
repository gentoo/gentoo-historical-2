# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythphone/mythphone-0.21_p17105.ebuild,v 1.4 2008/12/23 17:25:59 maekke Exp $

inherit mythtv-plugins subversion

DESCRIPTION="Phone and video calls with SIP."
IUSE="festival"
KEYWORDS="amd64 ppc x86"

RDEPEND="festival? ( app-accessibility/festival )"
DEPEND="${RDEPEND}"

MTVCONF=$(use_enable festival)
