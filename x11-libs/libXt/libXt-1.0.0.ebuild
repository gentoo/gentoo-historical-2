# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXt/libXt-1.0.0.ebuild,v 1.4 2006/02/14 22:43:48 corsair Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org Xt library"
#HOMEPAGE="http://foo.bar.com/"
#SRC_URI="ftp://foo.bar.com/${P}.tar.bz2"
#LICENSE=""
#SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
#IUSE="X gnome"
RDEPEND="x11-libs/libX11
	x11-libs/libSM
	x11-proto/xproto"
DEPEND="${RDEPEND}"
