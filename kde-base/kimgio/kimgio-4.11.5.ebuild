# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimgio/kimgio-4.11.5.ebuild,v 1.5 2014/02/16 07:18:44 ago Exp $

EAPI=5

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDE WebP image format plugin"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="media-libs/libwebp:="
RDEPEND="${DEPEND}"
