# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/oxygen-icons/oxygen-icons-4.8.5.ebuild,v 1.3 2012/09/02 23:15:58 ago Exp $

EAPI=4

if [[ ${PV} == *9999 ]]; then
	KMNAME="kdesupport"
else
	# Upstream does not ship releases properly so we dont want all versions
	MY_PV="4.8.5"
	MY_P="${PN}-${MY_PV}"
fi
KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Oxygen SVG icon theme."
HOMEPAGE="http://www.oxygen-icons.org/"
[[ ${PV} == *9999 ]] || \
SRC_URI="
	!bindist? ( http://dev.gentoo.org/~johu/distfiles/${MY_P}.repacked.tar.xz )
	bindist? ( ${SRC_URI//${PV}/${MY_PV}} )
"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="aqua bindist"

DEPEND=""
RDEPEND="${DEPEND}"

[[ ${PV} == *9999 ]] || S=${WORKDIR}/${MY_P}
