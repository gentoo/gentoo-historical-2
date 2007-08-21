# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythphone/mythphone-0.21_pre14242.ebuild,v 1.1 2007/08/21 16:24:30 cardoe Exp $

inherit mythtv-plugins subversion

DESCRIPTION="Phone and video calls with SIP."
IUSE="festival"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="festival? ( app-accessibility/festival )"
DEPEND="${RDEPEND}"

MTVCONF=$(use_enable festival)
