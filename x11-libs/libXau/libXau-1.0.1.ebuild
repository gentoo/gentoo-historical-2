# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXau/libXau-1.0.1.ebuild,v 1.8 2006/08/06 16:49:17 vapier Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Xau library"
RESTRICT="mirror"
#HOMEPAGE="http://foo.bar.com/"
#SRC_URI="ftp://foo.bar.com/${P}.tar.bz2"
#LICENSE=""
#SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
#IUSE="X gnome"
RDEPEND="x11-proto/xproto"
DEPEND="${RDEPEND}"
