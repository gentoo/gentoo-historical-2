# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Video-ivtv/Video-ivtv-0.12.ebuild,v 1.3 2006/08/06 01:00:55 mcummings Exp $

inherit perl-module

DESCRIPTION="Video::ivtv perl module, for use with ivtv-ptune"
HOMEPAGE="http://ivtv.sourceforge.net"
SRC_URI="mirror://sourceforge/ivtv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

export OPTIMIZE="$CFLAGS"
mydoc="README Changes COPYING"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
