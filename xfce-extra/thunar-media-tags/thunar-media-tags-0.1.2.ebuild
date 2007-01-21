# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/thunar-media-tags/thunar-media-tags-0.1.2.ebuild,v 1.1 2007/01/21 17:12:36 nichoj Exp $

inherit xfce44

xfce44_beta
xfce44_goodies_thunar_plugin

DESCRIPTION="Thunar media tags plugin"

KEYWORDS="~amd64 ~x86"

DEPEND=">=media-libs/taglib-1.4"
RDEPEND="${RDEPEND}"
