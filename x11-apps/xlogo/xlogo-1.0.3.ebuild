# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xlogo/xlogo-1.0.3.ebuild,v 1.6 2010/12/31 20:37:11 jer Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="X Window System logo"

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXaw
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"

CONFIGURE_OPTIONS="--with-render"
