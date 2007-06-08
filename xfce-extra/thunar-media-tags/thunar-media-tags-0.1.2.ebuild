# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/thunar-media-tags/thunar-media-tags-0.1.2.ebuild,v 1.17 2007/06/08 17:14:03 drac Exp $

inherit xfce44

xfce44

DESCRIPTION="Thunar media tags plugin"
KEYWORDS="~arm ~alpha amd64 hppa ia64 ppc ppc64 sparc x86"

RDEPEND=">=media-libs/taglib-1.4"
DEPEND="${RDEPEND}"

xfce44_goodies_thunar_plugin
