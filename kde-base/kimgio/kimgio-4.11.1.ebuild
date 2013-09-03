# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kimgio/kimgio-4.11.1.ebuild,v 1.1 2013/09/03 19:04:58 creffett Exp $

EAPI=5

KMNAME="kde-runtime"
inherit kde4-meta

DESCRIPTION="KDE WebP image format plugin"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="media-libs/libwebp"
RDEPEND="${DEPEND}"
