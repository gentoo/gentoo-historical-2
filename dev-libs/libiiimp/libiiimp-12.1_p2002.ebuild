# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libiiimp/libiiimp-12.1_p2002.ebuild,v 1.1.1.1 2005/11/30 09:42:13 chriswhite Exp $

inherit iiimf

DESCRIPTION="A generic C library which provides IIIM Protocol handling."
SRC_URI="http://www.openi18n.org/download/im-sdk/src/${IMSDK_P}.tar.bz2"

KEYWORDS="x86 ppc"
IUSE=""

S="${WORKDIR}/${IMSDK}/lib/iiimp"
