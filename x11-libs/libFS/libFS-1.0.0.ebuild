# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libFS/libFS-1.0.0.ebuild,v 1.2 2006/02/14 08:17:09 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org FS library"
#HOMEPAGE="http://foo.bar.com/"
#SRC_URI="ftp://foo.bar.com/${P}.tar.bz2"
#LICENSE=""
#SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc64 ~s390 ~sparc ~x86"
#IUSE="X gnome"
RDEPEND="x11-libs/xtrans
	x11-proto/xproto
	x11-proto/fontsproto"
DEPEND="${RDEPEND}"
IUSE="ipv6"

CONFIGURE_OPTIONS="$(use_enable ipv6)"
