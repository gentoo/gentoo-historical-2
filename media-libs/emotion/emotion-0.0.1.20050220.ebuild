# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-0.0.1.20050220.ebuild,v 1.1 2005/02/21 09:53:08 vapier Exp $

EHACKAUTOGEN=yes
inherit enlightenment

DESCRIPTION="video libraries for e17"

DEPEND=">=dev-libs/eet-0.9.9.20041031
	>=x11-libs/evas-1.0.0.20041031_pre13
	>=media-libs/edje-0.5.0.20041031
	>=x11-libs/ecore-1.0.0.20041031_pre7
	>=dev-libs/embryo-0.9.1.20041031
	>=media-libs/xine-lib-1_rc5"
